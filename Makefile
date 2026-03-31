COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all: up

up:
	mkdir -p /home/ssoumill/data/mariadb /home/ssoumill/data/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down -v --remove-orphans

fclean: clean
	docker system prune -af
	docker volume prune -f
	sudo rm -rf /home/ssoumill/data

re: fclean up

.PHONY: all up down build start stop restart logs ps clean fclean re
