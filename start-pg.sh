#!/bin/bash

VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  echo "Available versions: 14, 15, 16"
  exit 1
fi

# Check for valid versions
if [ "$VERSION" != "14" ] && [ "$VERSION" != "15" ] && [ "$VERSION" != "16" ]; then
  echo "Error: Invalid version '$VERSION'"
  echo "Available versions: 14, 15, 16"
  exit 1
fi

cd ~/personal/personal-repos/docker-timescaledb/v$VERSION
docker-compose up -d
echo "PostgreSQL v$VERSION started on port 54$VERSION"
