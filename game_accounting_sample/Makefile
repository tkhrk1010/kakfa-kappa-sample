# show make command list written in this file
help:
	@cat Makefile

start:
	docker-compose up -d

monitor:
	docker-compose logs -f game_app

test:
	bash ./script/test.sh

restart_game_app:
	docker-compose restart game_app
	docker-compose logs -f game_app

reset_db_volume:
	docker-compose down -v
	docker-compose build --no-cache postgres
	docker-compose up -d

clean:
	docker-compose down -v