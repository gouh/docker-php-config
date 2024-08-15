#!/bin/bash

UID = $(shell id -u)
PHP_CONTAINER = spei_front_server_php

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

start: ## [Container] Start the containers
	docker network create LOCAL || true
	U_ID=${UID} docker compose -f ./.docker/docker-compose.yml up -d

stop: ## [Container] Stop the containers
	U_ID=${UID} docker compose stop

restart: ## [Container] Restart the containers
	$(MAKE) stop && $(MAKE) start

build: ## [Container] Rebuilds all the containers
	docker network create LOCAL || true
	U_ID=${UID} docker compose build

build-start: ## [Container] Build and start containers
	docker network create LOCAL || true
	U_ID=${UID} docker compose -f ./.docker/docker-compose.yml up -d --build

down-rm-orphans: ## [Container] Down containers and remove orphans
	docker network create LOCAL || true
	U_ID=${UID} docker compose -f ./.docker/docker-compose.yml down --remove-orphans

dev-logs: ## [Logs] Show dev logs in real time
	U_ID=${UID} docker exec -it --user ${UID} ${PHP_CONTAINER} bash -c "tail -f ./var/log/dev.log"

prod-logs: ## [Logs] Show prod logs in real time
	U_ID=${UID} docker exec -it --user ${UID} ${PHP_CONTAINER} bash -c "tail -f ./var/log/prod.log"

composer-install: ## [Backend] Installs composer dependencies
	U_ID=${UID} docker exec --user ${UID} ${PHP_CONTAINER} composer install --no-interaction

clear-cache: ## [Backend] Clear cache
	U_ID=${UID} docker exec --user ${UID} ${PHP_CONTAINER} ./bin/console cache:clear

bash: ## [Interactive] Bash into the php container
	U_ID=${UID} docker exec -it --user ${UID} ${PHP_CONTAINER} bash
