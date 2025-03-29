all: up

TPUT	= tput -T xterm-256color
_RESET	=$(shell $(TPUT) srg0)
_BOLD	=$(shell $(TPUT) bold)
_ITALIC	=$(shell $(TPUT) sitm)
_UNDER	=$(shell $(TPUT) smul)
_GREEN	=$(shell $(TPUT) setaf 2)
_YELLOW	=$(shell $(TPUT) setaf 3)
_RED	=$(shell $(TPUT) setaf 1)
_GRAY	=$(shell $(TPUT) setaf 8)
_PURPLE	=$(shell $(TPUT) setaf 5)
_BLUE	=$(shell $(TPUT) setaf 26)

title:
	@printf "$(_BLUE)\n\n\
▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌\n\
▐ ██╗███╗   ██╗ ██████╗███████╗██████╗ ████████╗██╗ ██████╗ ███╗   ██╗ ▌\n\
▐ ██║████╗  ██║██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║ ▌\n\
▐ ██║██╔██╗ ██║██║     █████╗  ██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║ ▌\n\
▐ ██║██║╚██╗██║██║     ██╔══╝  ██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║ ▌\n\
▐ ██║██║ ╚████║╚██████╗███████╗██║        ██║   ██║╚██████╔╝██║ ╚████║ ▌\n\
▐ ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ▌\n\
▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌$(_RESET)\n\n\n"

up: title
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
	all up down clean fclean re title
