# PostgreSQL Multi-Version Docker Setup with TimescaleDB

This repository contains instructions and scripts for running multiple PostgreSQL versions (14, 15, 16) using Docker containers with TimescaleDB.

## Prerequisites

- Docker and Docker Compose are required.

## Directory Structure

Create a directory structure for your PostgreSQL Docker setup. You can place these directories anywhere you have permissions:

```bash
# Example in your home directory
mkdir -p ~/docker-timescaledb/{v14,v15,v16}/data
mkdir -p ~/docker-timescaledb/backups
```

## Create Docker Network

Create a shared network for your PostgreSQL containers:

```bash
docker network create postgres-network
```

## Create Docker Compose Files

Create Docker Compose files for PostgreSQL with TimescaleDB. Refer to the `docker-compose.yml` files in the `v14`, `v15` and `v16` directories.

## Create Utility Scripts

Create and use utility scripts for starting, stopping, and backing up PostgreSQL containers. Refer to the `start-pg.sh`, `stop-pg.sh`, and `backup-pg.sh` scripts in the repository.

## Start PostgreSQL Containers

Use the scripts to start PostgreSQL containers:

```bash
# Start PostgreSQL 16
~/docker-timescaledb/start-pg.sh 16
```

## Database Management

### Create Databases

```bash
# Create a new database with TimescaleDB for PostgreSQL 16
docker exec -it postgres16 createdb -U postgres your_app_name_development
```

### Create Users

```bash
# For PostgreSQL 16
docker exec -it postgres16 psql -U postgres -c "CREATE USER your_username WITH PASSWORD 'your_password';"
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

## Additional Tips

### Add Scripts to PATH (Optional)

For convenience, add the scripts to your PATH:

```bash
echo 'export PATH="$PATH:$HOME/docker-timescaledb"' >> ~/.bashrc
source ~/.bashrc
```

### View Logs

```bash
# View logs for PostgreSQL 16
docker logs postgres16
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

### Check Container Status

```bash
docker ps -a
```

### View Docker Compose Logs

```bash
cd ~/docker-timescaledb/v16
docker-compose logs
```

### Disk Space Issues

Check disk space usage for your Docker containers:

```bash
docker system df
```

Clean up unused Docker resources:

```bash
docker system prune
```
