all: up

up:
	mkdir -p /home/sabartho/data
	mkdir -p /home/sabartho/data/mariadb
	mkdir -p /home/sabartho/data/wordpress
	mkdir -p /home/sabartho/data/adminer
	mkdir -p /home/sabartho/data/minecraft
	docker compose -f ./srcs/docker-compose.yml up

down:
	docker compose -f ./srcs/docker-compose.yml down

clean: down
	rm -rf /home/sabartho/data

fclean: clean
	docker system prune -af

re: fclean all

.PHONY:
	all up down clean fclean re

