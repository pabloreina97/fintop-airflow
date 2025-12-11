#!/bin/bash
set -e

echo "=== Inicializando Airflow ==="

# Cargar variables de entorno
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

COMPOSE_FILE="${1:-docker/docker-compose.yml}"

# Inicializar base de datos
echo ">>> Inicializando base de datos..."
docker compose -f "$COMPOSE_FILE" run --rm airflow-init

echo "=== Airflow inicializado ==="
echo "Usuario: ${AIRFLOW_ADMIN_USER:-admin}"
echo "Accede a: http://localhost:8080"
