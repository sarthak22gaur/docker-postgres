# PostgreSQL Multi-Version Docker Setup with TimescaleDB

This repository contains instructions and scripts for running multiple PostgreSQL versions (14, 15, 16) using Docker containers with TimescaleDB and Redis

## Create Shared Networks

Create a shared network for your PostgreSQL containers:

```bash
docker network create postgres-network
```

If using Redis, also create a shared network for your redis containers:

```bash
docker network create redis-network
```

## Start PostgreSQL Containers

Use the scripts to start PostgreSQL containers:

```bash
# Start PostgreSQL 16
~/docker-timescaledb/start-pg.sh 16
```

```bash
# Start Redis
~/docker-timescaledb/start-redis.sh 16
```

## Database Management

### Create Users

```bash
# For PostgreSQL 16
docker exec -it postgres16 psql -U postgres -c "CREATE USER your_username WITH PASSWORD 'your_password';"
```

### Create Databases

```bash
# Create a new database with TimescaleDB for PostgreSQL 16
docker exec -it postgres16 createdb -U postgres your_app_name_development
```

### Grant Privileges

```bash
# For PostgreSQL 16
docker exec -it postgres16 psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE your_app_name_development TO your_username;"
```

### Enable TimescaleDB Extension

```bash
# For PostgreSQL 16
docker exec -it postgres16 psql -U postgres -d your_app_name_development -c "CREATE EXTENSION IF NOT EXISTS timescaledb;"
```

### Update pg_hba.conf

Ensure that the `pg_hba.conf` file is updated to remove the `scram-sha-256` authentication and use `trust` for local connections:

```bash
# Connect to the PostgreSQL container
docker exec -it postgres16 bash

# Edit the pg_hba.conf file
vi /var/lib/postgresql/data/pgdata/pg_hba.conf
```

```plaintext
# TYPE  DATABASE        USER            ADDRESS                 METHOD       

# Allow all connections without password
host    all             all             all                     trust
```

### Connect with psql

```bash
# Connect to PostgreSQL 16
docker exec -it postgres16 psql -U postgres
```

### Backup a Database

```bash
~/docker-timescaledb/backup-pg.sh 16 your_database_name
```

### Restore a Database

```bash
# First create the database if it doesn't exist
docker exec -it postgres16 createdb -U postgres your_database_name

# Then restore from a backup file
docker cp ~/docker-timescaledb/backups/your_backup_file.dump postgres16:/tmp/
docker exec -it postgres16 pg_restore -U postgres -d your_database_name /tmp/your_backup_file.dump
```

## Troubleshooting

### Container Won't Start

Check if ports are already in use:

```bash
sudo lsof -i :5416
```

### Data Permissions Issues

If you encounter permission errors with the data directory:

```bash
# Fix permissions (use with caution)
sudo chown -R 999:999 ~/docker-timescaledb/v16/data
```
