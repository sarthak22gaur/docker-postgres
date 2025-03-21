#!/bin/bash

cd ~/personal/personal-repos/docker-timescaledb/redis
docker-compose up -d
echo "Redis started on port 6379"
