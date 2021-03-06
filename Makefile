# Create new laravel application. Do Not execute this command if you've already created it in this directory.
WORKDIR=src
ifdef v
  VERSION = =${v}
  WORKDIR=v${v}
endif
up:
	docker run --rm -v ${PWD}:/app 708u/composer:1.9.3 composer create-project --prefer-dist laravel/laravel${VERSION} ${WORKDIR}
	cp environments/docker-compose.yml ${WORKDIR} \
		&& cp environments/public/.gitignore ${WORKDIR}/public \
		&& cp environments/config/dusk.php ${WORKDIR}/config \
		&& cp -R environments/docker ${WORKDIR} \
		&& cp -R environments/.github ${WORKDIR} \
		&& cp environments/Makefile ${WORKDIR}
	cat environments/.env.example >> ${WORKDIR}/.env.example
	sed -i \
		-e 's/DB_HOST=127.0.0.1/DB_HOST=mysql/g' \
		-e 's/DB_PASSWORD=/DB_PASSWORD=root/' \
		-e 's/CACHE_DRIVER=file/CACHE_DRIVER=redis/g' \
		-e 's/QUEUE_CONNECTION=sync/QUEUE_CONNECTION=redis/g' \
		-e 's/SESSION_DRIVER=file/SESSION_DRIVER=redis/g' \
		-e 's/REDIS_HOST=127.0.0.1/REDIS_HOST=redis/g' \
		${WORKDIR}/.env.example
	@echo new application succsessfully created in ${WORKDIR} !
