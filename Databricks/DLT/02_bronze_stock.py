import dlt

from pyspark.sql.functions import (
    col,
    current_timestamp,
    regexp_extract
)

from pyspark.sql.types import (
    StructType,
    StructField,
    StringType,
    TimestampType,
    LongType,
    BinaryType
)


# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

RAW_BASE_PATH = "/Volumes/demoworkspacejoby/stock_bronze/stock_data_staging"

DAILY_PRICES_PATH = f"{RAW_BASE_PATH}/daily_prices"
QUOTES_PATH = f"{RAW_BASE_PATH}/quotes"
COMPANY_INFO_PATH = f"{RAW_BASE_PATH}/company_info"


# ------------------------------------------------------------
# Schema for binaryFile streaming source
# ------------------------------------------------------------

binary_file_schema = StructType([
    StructField("path", StringType(), True),
    StructField("modificationTime", TimestampType(), True),
    StructField("length", LongType(), True),
    StructField("content", BinaryType(), True)
])


# ------------------------------------------------------------
# Reusable function for raw JSON file ingestion
# ------------------------------------------------------------

def read_raw_json_files(path):
    return (
        spark.readStream
            .format("binaryFile")
            .schema(binary_file_schema)
            .load(path)
            .select(
                regexp_extract(col("path"), r"symbol=([^/]+)", 1).alias("symbol"),
                col("content").cast("string").alias("_raw_json"),
                col("path").alias("_source_file"),
                col("modificationTime").alias("_source_modification_time"),
                col("length").alias("_source_file_size"),
                current_timestamp().alias("_ingest_timestamp")
            )
    )


# ------------------------------------------------------------
# Bronze Table 1: Raw Daily Stock Prices
# ------------------------------------------------------------

@dlt.table(
    name="bronze_daily_stock_raw",
    comment="Raw Alpha Vantage daily stock price JSON files."
)
def bronze_daily_stock_raw():
    return read_raw_json_files(DAILY_PRICES_PATH)


# ------------------------------------------------------------
# Bronze Table 2: Raw Latest Quote
# ------------------------------------------------------------

@dlt.table(
    name="bronze_quote_raw",
    comment="Raw Alpha Vantage latest quote JSON files."
)
def bronze_quote_raw():
    return read_raw_json_files(QUOTES_PATH)


# ------------------------------------------------------------
# Bronze Table 3: Raw Company Info
# ------------------------------------------------------------

@dlt.table(
    name="bronze_company_info_raw",
    comment="Raw Alpha Vantage company overview JSON files."
)
def bronze_company_info_raw():
    return read_raw_json_files(COMPANY_INFO_PATH)