# show make command list written in this file
help:
	@cat Makefile

monitor:
	docker-compose logs -f ruby_app

restart_ruby_app:
	docker-compose restart ruby_app
	docker-compose logs -f ruby_app
