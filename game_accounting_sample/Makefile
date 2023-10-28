help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


start: ## Start the game_app container
	docker-compose up -d

monitor: ## Monitor the game_app container
	docker-compose logs -f game_app

test: ## Run the test script
	bash ./script/test.sh

restart_game_app: ## Restart the game_app container
	docker-compose restart game_app
	docker-compose logs -f game_app

reset_db_volume: ## Reset the database volume
	docker-compose down -v
	docker-compose build --no-cache postgres
	docker-compose up -d

rebuild_game_app: ## Rebuild the game_app container
	docker-compose build --no-cache game_app
	docker-compose up -d

clean: ## Clean the game_app container
	docker-compose down -v


BROKER_ADDRESS=localhost:9092

clean-topic: ## Clean the Kafka topic
	# Delete the topic
	docker exec -it game_accounting_sample-kafka-1 kafka-topics --delete --bootstrap-server $(BROKER_ADDRESS) --topic game
	docker exec -it game_accounting_sample-kafka-1 kafka-topics --delete --bootstrap-server $(BROKER_ADDRESS) --topic credit
	
	# Sleep for a while to ensure topic deletion completes
	sleep 5

	# Create the topic again
	docker exec -it game_accounting_sample-kafka-1 kafka-topics --create --bootstrap-server $(BROKER_ADDRESS) --topic game --partitions 1 --replication-factor 1
	docker exec -it game_accounting_sample-kafka-1 kafka-topics --create --bootstrap-server $(BROKER_ADDRESS) --topic credit --partitions 1 --replication-factor 1

.PHONY: clean-kafka