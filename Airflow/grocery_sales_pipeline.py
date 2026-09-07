from datetime import datetime

from airflow.sdk import DAG
from airflow.providers.microsoft.azure.operators.data_factory import (
    AzureDataFactoryRunPipelineOperator,
)
from airflow.providers.standard.operators.bash import BashOperator


DBT_PROJECT_DIR = "/mnt/c/Users/Dell/grocery-sales-data-processing"


with DAG(
    dag_id="grocery_sales_pipeline",
    start_date=datetime(2026, 9, 5),
    schedule=None,
    catchup=False,
    tags=["grocery-sales", "azure", "dbt", "pytest"],
) as dag:

    run_adf_ingestion = AzureDataFactoryRunPipelineOperator(
        task_id="run_adf_ingestion",
        azure_data_factory_conn_id="azure_data_factory_default",
        resource_group_name="P2-Project",
        factory_name="p2adfff",
        pipeline_name="PL_Ingest_TXT_to_Parquet",
        wait_for_termination=True,
    )

    run_dbt_silver = BashOperator(
        task_id="run_dbt_silver",
        bash_command=(
            "source /home/pranay/airflow/.grocery_env && "
            f"cd {DBT_PROJECT_DIR} && "
            "dbt run --select staging intermediate"
        ),
    )

    run_dbt_gold = BashOperator(
        task_id="run_dbt_gold",
        bash_command=(
            "source /home/pranay/airflow/.grocery_env && "
            f"cd {DBT_PROJECT_DIR} && "
            "dbt run --select marts"
        ),
    )

    run_pytest = BashOperator(
        task_id="run_pytest",
        bash_command=(
            "source /home/pranay/airflow/.grocery_env && "
            f"cd {DBT_PROJECT_DIR} && "
            "python -m pytest -v"
        ),
    )

    run_adf_ingestion >> run_dbt_silver >> run_dbt_gold >> run_pytest
