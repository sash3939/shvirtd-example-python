#!/bin/bash

# Загружаем переменные окружения из файла .env
export $(grep -v '^#' /opt/backup/.env | xargs)

# Директория для резервных копий
BACKUP_DIR="/opt/backup"
TIMESTAMP=$(date +"%F_%T")
BACKUP_FILE="${BACKUP_DIR}/backup_${MYSQL_DATABASE}_${TIMESTAMP}.sql"

# Запуск контейнера для создания резервной копии
docker run --rm \
    --network backend \
    -v ${BACKUP_DIR}:/backup \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    schnitzler/mysqldump \
    mysqldump -h mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} > ${BACKUP_FILE}

# Проверка результата
if [ $? -eq 0 ]; then
    echo "Backup successful: ${BACKUP_FILE}"
else
    echo "Backup failed"
fi
