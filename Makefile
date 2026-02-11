# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vpelc <vpelc@student.s19.be>               +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/01/28 14:43:37 by vpelc             #+#    #+#              #
#    Updated: 2026/02/03 15:23:41 by vpelc            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception

COMPOSE_FILE = src/docker-compose.yml

DATA_PATH = /home/$(USER)/data

all : build up

build : 
	@echo "\e[1;36mBuilding Docker images\e[0m"
	@mkdir -p $(DATA_PATH)/mysql $(DATA_PATH)/wordpress
	@cd src/ && sudo docker compose build

up :
	@echo "\e[1;33mStarting containers\e[0m"
	@cd src/ && sudo docker compose up
		
down:
	@echo "\e[1;31mStopping containers\e[0m"
	@cd src/ && sudo docker compose down
		
clean: down
	@echo "\e[1;32mCleaning up\e[0m"
	@sudo docker system prune -af
	@sudo docker volume prune -f
	
fclean: clean
	@echo "\e[1;35mFull cleanup\e[0m"
	@sudo rm -rf $(DATA_PATH)
	@sudo docker system prune -af --volumes

re: fclean all

logs:
	@timeout 30s docker compose -f $(COMPOSE_FILE) logs -f || echo "Log viewing timed out"

status:
	@sudo docker compose -f $(COMPOSE_FILE) ps

.PHONY: all build up down clean fclean re logs status
