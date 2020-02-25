# docker-compose up -d
.PHONY: up
up:
	docker-compose up -d

# docker-compose ps
.PHONY: ps
ps:
	docker-compose ps

# docker-compose stop
.PHONY: stop
stop:
	docker-compose stop

# docker-compose restart
.PHONY: restart
restart:
	docker-compose restart

# docker-compose down
.PHONY: down
down:
	docker-compose down

# Create new laravel application. Do Not execute this command if you've already created it this directory.
.PHONY: create-laravel-app
laravel-app:
	docker run --rm -v ${PWD}:/app 708u/composer:1.9.3 composer create-project --prefer-dist laravel/laravel src
	cp docker-compose.yml src/ && cp -R docker src/ && cp Makefile src/

# Install laravel project from dependencies and initialize environments.
.PHONY: install
install:
	docker-compose up -d --build
	cp .env.example .env
	docker run --rm -v ${PWD}:/app 708u/composer:1.9.3 composer install
	docker-compose exec node yarn install --force
	docker-compose exec app php artisan key:generate
	docker-compose exec app php artisan migrate:fresh --seed
	docker-compose restart
