from pyspark.sql import SparkSession
from pyspark.sql import functions as F

spark = SparkSession.builder.getOrCreate()

GOLD_FACT = "adb_p2_grocery_serverless.gold.fact_sales"
SILVER_STORE = "adb_p2_grocery_serverless.silver.stg_stores"


def test_fact_sales_not_empty():
    df = spark.table(GOLD_FACT)
    assert df.count() > 0


def test_fact_sales_no_nulls():
    df = spark.table(GOLD_FACT)

    null_count = df.filter(
        F.col("sales_id").isNull()
        | F.col("sales_date").isNull()
        | F.col("store_nbr").isNull()
        | F.col("family").isNull()
        | F.col("sales").isNull()
    ).count()

    assert null_count == 0


def test_fact_sales_no_duplicate_ids():
    df = spark.table(GOLD_FACT)

    duplicate_count = (
        df.groupBy("sales_id")
        .count()
        .filter(F.col("count") > 1)
        .count()
    )

    assert duplicate_count == 0


def test_onpromotion_not_negative():
    df = spark.table(GOLD_FACT)

    negative_promotions = df.filter(
        F.col("onpromotion") < 0
    ).count()

    assert negative_promotions == 0


def test_store_number_unique():
    df = spark.table(SILVER_STORE)

    duplicates = (
        df.groupBy("store_nbr")
        .count()
        .filter(F.col("count") > 1)
        .count()
    )

    assert duplicates == 0


def test_gold_dimensions_not_empty():
    tables = [
        "dim_date",
        "dim_product",
        "dim_store",
    ]

    for table in tables:
        df = spark.table(
            f"adb_p2_grocery_serverless.gold.{table}"
        )
        assert df.count() > 0, f"{table} is empty"


def test_fact_sales_required_columns():
    df = spark.table(GOLD_FACT)

    required_columns = [
        "sales_id",
        "sales_date",
        "store_nbr",
        "family",
        "sales"
    ]

    missing_columns = [
        column
        for column in required_columns
        if column not in df.columns
    ]

    assert missing_columns == []


def test_fact_sales_valid_dates():
    df = spark.table(GOLD_FACT)

    invalid_dates = df.filter(
        F.col("sales_date").isNull()
    ).count()

    assert invalid_dates == 0
