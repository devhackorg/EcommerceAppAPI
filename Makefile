ENVIRONMENT_FILE=.env

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install:
ifeq ($(wildcard $(ENVIRONMENT_FILE)),)
	- @echo O arquivo ".env" não existe;
else
	- docker network create --driver bridge devhack_ecommerce_net
	- docker-compose up -d --build
	- docker-compose exec ecommerce-api-php composer install
	- docker-compose exec ecommerce-api-php php artisan storage:link
	- sudo chown -R 33:33 bootstrap/ storage/
	- docker-compose exec ecommerce-api-php php artisan config:cache
	- docker-compose exec ecommerce-api-php php artisan key:generate
endif

clean:
	- sudo rm -rf vendor
	- docker-compose down
	- docker rmi ecommerce-app-api-ecommerce-api-php

clear:
	- docker-compose exec ecommerce-api-php php artisan config:clear
	- docker-compose exec ecommerce-api-php php artisan cache:clear
	- docker-compose exec ecommerce-api-php php artisan view:clear
	- docker-compose exec ecommerce-api-php php artisan route:clear
	- docker-compose exec ecommerce-api-php composer dump-autoload

run:
	- docker-compose start
	- docker-compose exec ecommerce-api-php composer install
	- docker-compose exec ecommerce-api-php php artisan config:cache
	- sudo chown -R 33:33 bootstrap/ storage/

start:
	- docker-compose start

stop:
	- docker-compose stop

restart:
	- docker-compose restart
	- docker-compose exec ecommerce-api-php composer install
	- docker-compose exec ecommerce-api-php php artisan config:cache

status:
	- docker-compose ps

seed-dev:
	- docker-compose exec ecommerce-api-php php artisan db:seed

migrate:
	- docker-compose exec ecommerce-api-php php artisan migrate

reset:
	- docker-compose exec ecommerce-api-php php artisan migrate:reset

bash:
	- docker-compose exec -it --user 1000:1000 ecommerce-api-php bash

bash-server:
	- docker-compose exec -it ecommerce-api-nginx bash
