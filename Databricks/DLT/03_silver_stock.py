import dlt

from pyspark.sql.functions import (
    col,
    explode,
    from_json,
    current_timestamp,
    regexp_replace
)

from pyspark.sql.types import (
    StructType,
    StructField,
    StringType,
    MapType
)


# ------------------------------------------------------------
# Schema 1: Alpha Vantage TIME_SERIES_DAILY response
# ------------------------------------------------------------

daily_price_schema = StructType([
    StructField("Meta Data", StructType([
        StructField("1. Information", StringType(), True),
        StructField("2. Symbol", StringType(), True),
        StructField("3. Last Refreshed", StringType(), True),
        StructField("4. Output Size", StringType(), True),
        StructField("5. Time Zone", StringType(), True)
    ]), True),

    StructField("Time Series (Daily)", MapType(
        StringType(),
        StructType([
            StructField("1. open", StringType(), True),
            StructField("2. high", StringType(), True),
            StructField("3. low", StringType(), True),
            StructField("4. close", StringType(), True),
            StructField("5. volume", StringType(), True)
        ])
    ), True)
])


# ------------------------------------------------------------
# Schema 2: Alpha Vantage GLOBAL_QUOTE response
# ------------------------------------------------------------

quote_schema = StructType([
    StructField("Global Quote", StructType([
        StructField("01. symbol", StringType(), True),
        StructField("02. open", StringType(), True),
        StructField("03. high", StringType(), True),
        StructField("04. low", StringType(), True),
        StructField("05. price", StringType(), True),
        StructField("06. volume", StringType(), True),
        StructField("07. latest trading day", StringType(), True),
        StructField("08. previous close", StringType(), True),
        StructField("09. change", StringType(), True),
        StructField("10. change percent", StringType(), True)
    ]), True)
])


# ------------------------------------------------------------
# Schema 3: Alpha Vantage OVERVIEW response
# Minimal company fields only
# ------------------------------------------------------------

company_info_schema = StructType([
    StructField("Symbol", StringType(), True),
    StructField("Name", StringType(), True),
    StructField("AssetType", StringType(), True),
    StructField("Exchange", StringType(), True),
    StructField("Currency", StringType(), True),
    StructField("Country", StringType(), True),
    StructField("Sector", StringType(), True),
    StructField("Industry", StringType(), True),
    StructField("MarketCapitalization", StringType(), True),
    StructField("PERatio", StringType(), True),
    StructField("EPS", StringType(), True),
    StructField("DividendYield", StringType(), True)
])


# ------------------------------------------------------------
# Silver Table 1: Daily Stock Prices
# ------------------------------------------------------------

@dlt.table(
    name="silver_daily_stock_prices",
    comment="Parsed and typed daily stock price records from Alpha Vantage TIME_SERIES_DAILY."
)
@dlt.expect_or_drop("valid_symbol", "symbol IS NOT NULL")
@dlt.expect_or_drop("valid_trade_date", "trade_date IS NOT NULL")
@dlt.expect_or_drop("valid_close_price", "close_price > 0")
def silver_daily_stock_prices():
    bronze_df = dlt.read_stream("bronze_daily_stock_raw")

    parsed_df = (
        bronze_df
        .withColumn("parsed_json", from_json(col("_raw_json"), daily_price_schema))
        .withColumn("daily_prices", col("parsed_json.`Time Series (Daily)`"))
        .select(
            col("symbol"),
            col("_source_file"),
            col("_ingest_timestamp"),
            explode(col("daily_prices")).alias("trade_date_string", "price_data")
        )
    )

    return (
        parsed_df
        .select(
            col("symbol"),
            col("trade_date_string").cast("date").alias("trade_date"),
            col("price_data.`1. open`").cast("double").alias("open_price"),
            col("price_data.`2. high`").cast("double").alias("high_price"),
            col("price_data.`3. low`").cast("double").alias("low_price"),
            col("price_data.`4. close`").cast("double").alias("close_price"),
            col("price_data.`5. volume`").cast("long").alias("volume"),
            col("_source_file"),
            col("_ingest_timestamp"),
            current_timestamp().alias("_silver_processed_timestamp")
        )
    )


# ------------------------------------------------------------
# Silver Table 2: Latest Quote
# ------------------------------------------------------------

@dlt.table(
    name="silver_latest_quote",
    comment="Parsed and typed latest quote data from Alpha Vantage GLOBAL_QUOTE."
)
@dlt.expect_or_drop("valid_symbol", "symbol IS NOT NULL")
@dlt.expect_or_drop("valid_latest_price", "latest_price > 0")
def silver_latest_quote():
    bronze_df = dlt.read_stream("bronze_quote_raw")

    parsed_df = (
        bronze_df
        .withColumn("parsed_json", from_json(col("_raw_json"), quote_schema))
        .withColumn("quote", col("parsed_json.`Global Quote`"))
    )

    return (
        parsed_df
        .select(
            col("symbol"),
            col("quote.`07. latest trading day`").cast("date").alias("latest_trading_day"),
            col("quote.`02. open`").cast("double").alias("open_price"),
            col("quote.`03. high`").cast("double").alias("high_price"),
            col("quote.`04. low`").cast("double").alias("low_price"),
            col("quote.`05. price`").cast("double").alias("latest_price"),
            col("quote.`06. volume`").cast("long").alias("volume"),
            col("quote.`08. previous close`").cast("double").alias("previous_close"),
            col("quote.`09. change`").cast("double").alias("price_change"),
            regexp_replace(col("quote.`10. change percent`"), "%", "").cast("double").alias("change_percent"),
            col("_source_file"),
            col("_ingest_timestamp"),
            current_timestamp().alias("_silver_processed_timestamp")
        )
    )


# ------------------------------------------------------------
# Silver Table 3: Company Info
# ------------------------------------------------------------

@dlt.table(
    name="silver_company_info",
    comment="Parsed company overview data with basic company profile and key valuation fields."
)
@dlt.expect_or_drop("valid_symbol", "symbol IS NOT NULL")
@dlt.expect_or_drop("valid_company_name", "company_name IS NOT NULL")
def silver_company_info():
    bronze_df = dlt.read_stream("bronze_company_info_raw")

    parsed_df = (
        bronze_df
        .withColumn("parsed_json", from_json(col("_raw_json"), company_info_schema))
    )

    return (
        parsed_df
        .select(
            col("symbol"),
            col("parsed_json.Name").alias("company_name"),
            col("parsed_json.AssetType").alias("asset_type"),
            col("parsed_json.Exchange").alias("exchange"),
            col("parsed_json.Currency").alias("currency"),
            col("parsed_json.Country").alias("country"),
            col("parsed_json.Sector").alias("sector"),
            col("parsed_json.Industry").alias("industry"),
            col("parsed_json.MarketCapitalization").cast("long").alias("market_capitalization"),
            col("parsed_json.PERatio").cast("double").alias("pe_ratio"),
            col("parsed_json.EPS").cast("double").alias("eps"),
            col("parsed_json.DividendYield").cast("double").alias("dividend_yield"),
            col("_source_file"),
            col("_ingest_timestamp"),
            current_timestamp().alias("_silver_processed_timestamp")
        )
    )