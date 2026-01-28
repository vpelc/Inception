# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vpelc <vpelc@student.s19.be>               +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/01/28 14:43:37 by vpelc             #+#    #+#              #
#    Updated: 2026/01/28 15:44:05 by vpelc            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all :
		@docker-compose -f src/docker-compose.yml up --build -d --no-cache

up :
		@docker-compose -f src/docker-compose.yml up -d
		
down:
		@docker-compose -f src/docker-compose.yml down
		
clean: 
		@chmod 744 clean.sh
		@./clean.sh

info:	
		@echo
		@echo "\e[1;33m---networks---\e[0m"
		@docker network ls
		@echo
		@echo "\e[1;32m---mounted images---\e[0m"
		@docker images
		@echo
		@echo "\e[1;36m---containers---\e[0m"
		@docker ps -a
		@echo
		@echo "\e[1;35---volumes---\e[0m"
		@docker volumes ls

.PHONY: all up down clean info 