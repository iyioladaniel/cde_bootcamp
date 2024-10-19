from airflow import DAG
from airflow.utils.dates import datetime
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow_project.includes.download_wikipedia_pageviews import download_wikipedia_pageviews

with DAG(
    dag_id = "wikipedia_pageviews",
    schedule_interval=None,
    start_date=datetime(2024, 10, 19)
) as dag:
    
    #Task to download and extract the data using python
    download_pageviews = PythonOperator(
        task_id="download_pageviews",
        python_callable=download_wikipedia_pageviews
    )
    
    extract_file = BashOperator(
        task_id="extract_data",
        bash_command="""
        gunzip /workspaces/airflow/dags/airflow_project/pageviews/pageviews-20241019-100000.gz
        """
    )
    
    analyse_data = SQLExecuteQueryOperator(
        task_id="execute_query",
        sql = f"SELECT * FROM {} LIMIT 1;"
        split_statements = true
    )