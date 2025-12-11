#!/bin/bash
set -e

echo "=== Iniciando deploy en Raspberry Pi ==="

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

# Detener servicios actuales
echo ">>> Deteniendo servicios..."
docker compose -f "$COMPOSE_FILE" down || true

# Construir nuevas imágenes
echo ">>> Construyendo imagen Docker..."
docker compose -f "$COMPOSE_FILE" build

# Iniciar servicios
echo ">>> Iniciando servicios..."
docker compose -f "$COMPOSE_FILE" up -d

# Esperar a que los servicios estén listos
echo ">>> Esperando a que Airflow esté listo..."
sleep 30

# Verificar estado
echo ">>> Estado de los servicios:"
docker compose -f "$COMPOSE_FILE" ps

# Limpiar imágenes antiguas
echo ">>> Limpiando imágenes antiguas..."
docker image prune -f

echo "=== Deploy completado ==="
