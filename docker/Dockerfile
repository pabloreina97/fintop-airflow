# Dockerfile optimizado para Raspberry Pi (ARM64)
FROM apache/airflow:2.8.1-python3.11

# Variables de entorno optimizadas para Raspberry Pi
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False \
    AIRFLOW__CORE__EXECUTOR=LocalExecutor \
    AIRFLOW__WEBSERVER__WORKERS=1 \
    AIRFLOW__WEBSERVER__WEB_SERVER_MASTER_TIMEOUT=300 \
    AIRFLOW__WEBSERVER__WEB_SERVER_WORKER_TIMEOUT=300 \
    AIRFLOW__SCHEDULER__MIN_FILE_PROCESS_INTERVAL=60 \
    AIRFLOW__SCHEDULER__PARSING_PROCESSES=1 \
    AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION=True \
    AIRFLOW__CORE__MAX_ACTIVE_RUNS_PER_DAG=2

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
