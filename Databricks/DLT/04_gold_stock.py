import dlt

from pyspark.sql import functions as F
from pyspark.sql.window import Window


def get_latest_daily_prices():
    """
    Return the latest ingested daily price record for each symbol and trade date.
    """
    daily_df = dlt.read("silver_daily_stock_prices")

    daily_window = Window.partitionBy("symbol", "trade_date").orderBy(
        F.col("_ingest_timestamp").desc()
    )

    return (
        daily_df
        .withColumn("row_num", F.row_number().over(daily_window))
        .filter(F.col("row_num") == 1)
        .drop("row_num")
    )


@dlt.table(
    name="gold_stock_price_trends",
    comment="Daily stock price trends with rolling price and volume metrics."
)
def gold_stock_price_trends():
    daily_df = get_latest_daily_prices()

    symbol_window = Window.partitionBy("symbol").orderBy("trade_date")

    rolling_7_day_window = Window.partitionBy("symbol").orderBy("trade_date").rowsBetween(-6, 0)
    rolling_30_day_window = Window.partitionBy("symbol").orderBy("trade_date").rowsBetween(-29, 0)
    rolling_90_day_window = Window.partitionBy("symbol").orderBy("trade_date").rowsBetween(-89, 0)

    return (
        daily_df
        .withColumn("close_7d_ago", F.lag("close_price", 7).over(symbol_window))
        .withColumn("close_30d_ago", F.lag("close_price", 30).over(symbol_window))
        .withColumn("close_90d_ago", F.lag("close_price", 90).over(symbol_window))

        .withColumn("price_change_7d", F.round(F.col("close_price") - F.col("close_7d_ago"), 2))
        .withColumn("price_change_30d", F.round(F.col("close_price") - F.col("close_30d_ago"), 2))
        .withColumn("price_change_90d", F.round(F.col("close_price") - F.col("close_90d_ago"), 2))

        .withColumn(
            "price_pct_change_7d",
            F.round((F.col("close_price") - F.col("close_7d_ago")) / F.col("close_7d_ago") * 100, 2)
        )
        .withColumn(
            "price_pct_change_30d",
            F.round((F.col("close_price") - F.col("close_30d_ago")) / F.col("close_30d_ago") * 100, 2)
        )
        .withColumn(
            "price_pct_change_90d",
            F.round((F.col("close_price") - F.col("close_90d_ago")) / F.col("close_90d_ago") * 100, 2)
        )

        .withColumn("avg_volume_7d", F.round(F.avg("volume").over(rolling_7_day_window), 0))
        .withColumn("avg_volume_30d", F.round(F.avg("volume").over(rolling_30_day_window), 0))
        .withColumn("avg_volume_90d", F.round(F.avg("volume").over(rolling_90_day_window), 0))

        .select(
            "symbol",
            "trade_date",
            "open_price",
            "high_price",
            "low_price",
            "close_price",
            "volume",
            "price_change_7d",
            "price_change_30d",
            "price_change_90d",
            "price_pct_change_7d",
            "price_pct_change_30d",
            "price_pct_change_90d",
            "avg_volume_7d",
            "avg_volume_30d",
            "avg_volume_90d"
        )
    )


def get_latest_quotes():
    """
    Return the latest quote record for each symbol.
    """
    quote_df = dlt.read("silver_latest_quote")

    quote_window = Window.partitionBy("symbol").orderBy(
        F.col("_ingest_timestamp").desc()
    )

    return (
        quote_df
        .withColumn("row_num", F.row_number().over(quote_window))
        .filter(F.col("row_num") == 1)
        .drop("row_num")
    )


def get_latest_company_info():
    """
    Return the latest company profile record for each symbol.
    """
    company_df = dlt.read("silver_company_info")

    company_window = Window.partitionBy("symbol").orderBy(
        F.col("_ingest_timestamp").desc()
    )

    return (
        company_df
        .withColumn("row_num", F.row_number().over(company_window))
        .filter(F.col("row_num") == 1)
        .drop("row_num")
    )


@dlt.table(
    name="gold_latest_stock_snapshot",
    comment="Latest stock quote enriched with company profile attributes."
)
def gold_latest_stock_snapshot():
    quote_df = get_latest_quotes()
    company_df = get_latest_company_info()

    return (
        quote_df.alias("q")
        .join(company_df.alias("c"), on="symbol", how="left")
        .select(
            F.col("q.symbol"),
            F.col("c.company_name"),
            F.col("c.exchange"),
            F.col("c.currency"),
            F.col("c.country"),
            F.col("c.sector"),
            F.col("c.industry"),
            F.col("q.latest_trading_day"),
            F.col("q.latest_price"),
            F.col("q.previous_close"),
            F.col("q.price_change"),
            F.col("q.change_percent"),
            F.col("q.volume"),
            F.col("c.market_capitalization"),
            F.col("c.pe_ratio"),
            F.col("c.eps"),
            F.col("c.dividend_yield")
        )
    )


@dlt.table(
    name="gold_company_valuation_summary",
    comment="Company-level valuation and profile summary for tracked symbols."
)
def gold_company_valuation_summary():
    company_df = get_latest_company_info()

    return (
        company_df
        .select(
            "symbol",
            "company_name",
            "exchange",
            "currency",
            "country",
            "sector",
            "industry",
            "market_capitalization",
            "pe_ratio",
            "eps",
            "dividend_yield"
        )
    )


@dlt.table(
    name="gold_sector_summary",
    comment="Sector-level valuation summary for tracked companies."
)
def gold_sector_summary():
    company_df = get_latest_company_info()

    return (
        company_df
        .groupBy("sector")
        .agg(
            F.countDistinct("symbol").alias("company_count"),
            F.round(F.avg("market_capitalization"), 2).alias("avg_market_capitalization"),
            F.round(F.avg("pe_ratio"), 2).alias("avg_pe_ratio"),
            F.round(F.avg("eps"), 2).alias("avg_eps"),
            F.round(F.avg("dividend_yield"), 4).alias("avg_dividend_yield")
        )
        .orderBy(F.col("avg_market_capitalization").desc())
    )