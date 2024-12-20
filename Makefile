
COMPOSE_FILE = srcs/docker-compose.yml

up:
	mkdir -p /home/seongjko/data/wordpress
	mkdir -p /home/seongjko/data/mariadb
	chmod 777 /home/seongjko/data

	docker-compose -f $(COMPOSE_FILE) up -d --build
	
stop:
	docker-compose -f $(COMPOSE_FILE) stop

stop-nginx:
	docker-compose -f $(COMPOSE_FILE) stop nginx

stop-mariadb:
	docker-compose -f $(COMPOSE_FILE) stop mariadb

stop-wordpress:
	docker-compose -f $(COMPOSE_FILE) stop wordpress

start:
	docker-compose -f $(COMPOSE_FILE) start

start-nginx:
	docker-compose -f $(COMPOSE_FILE) start nginx

start-mariadb:
	docker-compose -f $(COMPOSE_FILE) start mariadb

start-wordpress:
	docker-compose -f $(COMPOSE_FILE) start wordpress

clean:
	docker-compose -f $(COMPOSE_FILE) down --rmi all -v
	docker volume prune -f
	docker image prune -af
	# sudo rm -rf /Users/goseongjun/data
	sudo rm -rf /home/seongjko/data

.PHONY: up stop stop-nginx stop-mariadb stop-wordpress \
		start start-nginx start-mariadb start-wordpress \
		clean