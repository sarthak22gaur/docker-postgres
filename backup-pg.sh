#!/bin/bash

VERSION=$1
DB_NAME=$2

if [ -z "$VERSION" ] || [ -z "$DB_NAME" ]; then
  echo "Usage: $0 <version> <database-name>"
  echo "Available versions: 14, 15, 16"
  exit 1
fi

# Check for valid versions
if [ "$VERSION" != "14" ] && [ "$VERSION" != "15" ] && [ "$VERSION" != "16" ]; then
  echo "Error: Invalid version '$VERSION'"
  echo "Available versions: 14, 15, 16"
  exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=~/personal/personal-repos/docker-timescaledb/backups
mkdir -p $BACKUP_DIR

docker exec postgres$VERSION pg_dump -U postgres -d $DB_NAME -F c -f /tmp/$DB_NAME.dump
docker cp postgres$VERSION:/tmp/$DB_NAME.dump $BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.dump

echo "Backup created at $BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.dump"
