#!/bin/bash
set -e

echo "=== Iniciando deploy en Raspberry Pi ==="

# Cargar variables de entorno
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

COMPOSE_FILE="docker/docker-compose.prod.yml"
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"

# Crear directorio de datos si no existe
mkdir -p data logs backups

# Backup de la base de datos
if [ -f "airflow.db" ]; then
    echo ">>> Creando backup de la base de datos..."
    mkdir -p "$BACKUP_DIR"
    cp airflow.db "$BACKUP_DIR/"
    echo "    Backup guardado en $BACKUP_DIR"
fi

# Reiniciar servicios (sin rebuild, usa cache)
echo ">>> Reiniciando servicios..."
docker compose --env-file .env -f "$COMPOSE_FILE" up -d --force-recreate

# Esperar a que los servicios estén listos
echo ">>> Esperando a que Airflow esté listo..."
sleep 30

# Verificar estado
echo ">>> Estado de los servicios:"
docker compose --env-file .env -f "$COMPOSE_FILE" ps

# Limpiar imágenes antiguas
echo ">>> Limpiando imágenes antiguas..."
docker image prune -f

echo "=== Deploy completado ==="
