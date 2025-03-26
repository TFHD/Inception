all: up

up:
	@docker-compose -f ./srcs/docker-compose.yml up --build
clean:
	@docker-compose -f ./srcs/docker-compose.yml down

fclean: clean

re: fclean all

.PHONY: clean fclean re all
