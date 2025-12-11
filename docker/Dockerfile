# Dockerfile optimizado para Raspberry Pi (ARM64)
FROM apache/airflow:2.8.1-python3.11

# Variables de entorno optimizadas para Raspberry Pi
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False \
    AIRFLOW__CORE__EXECUTOR=SequentialExecutor \
    AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=sqlite:////opt/airflow/airflow.db \
    AIRFLOW__WEBSERVER__WORKERS=2 \
    AIRFLOW__SCHEDULER__MIN_FILE_PROCESS_INTERVAL=30 \
    AIRFLOW__SCHEDULER__PARSING_PROCESSES=1 \
    AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION=True \
    AIRFLOW__CORE__MAX_ACTIVE_RUNS_PER_DAG=3

USER airflow

# Copiar requirements primero para aprovechar cache de layers
COPY --chown=airflow:root requirements.txt /tmp/requirements.txt

# Instalar dependencias
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copiar DAGs y plugins
COPY --chown=airflow:root dags/ ${AIRFLOW_HOME}/dags/
COPY --chown=airflow:root plugins/ ${AIRFLOW_HOME}/plugins/

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl --fail http://localhost:8080/health || exit 1
