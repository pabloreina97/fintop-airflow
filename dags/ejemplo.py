"""DAG de ejemplo para verificar que Airflow funciona correctamente."""
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    "owner": "pablo",
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="ejemplo",
    description="DAG de ejemplo para verificar el funcionamiento de Airflow",
    start_date=datetime(2025, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args=default_args,
    tags=["ejemplo", "test"],
):
    tarea_hola = BashOperator(
        task_id="hola",
        bash_command="echo 'Hola desde mi DAG!'",
    )

    tarea_fecha = BashOperator(
        task_id="mostrar_fecha",
        bash_command="date",
    )

    tarea_hola >> tarea_fecha
