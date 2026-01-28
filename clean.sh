#!/bin/bash

rm -rf /home/vpelc/wordpress_data/*
rm -rf /home/vpelc/mariadb_data/*
docker rmi -f $(docker images -aq) && make down && docker volume rm -f $(docker volume ls -q)#!/bin/bash

docker-compose -f src/docker-compose.yml down
docker stop $(docker ps -qa) 2>/dev/null
docker rm $(docker ps -qa) 2>/dev/null
docker rmi -f $(docker images -qa) 2>/dev/null
docker volume rm $(docker volumes ls -q) 2>/dev/null
docker network rm $(docker network ls -q) 2>/dev/null
docker system prune -a --volume 2>/dev/null
docker sustem prune -a --force 2>/dev/null