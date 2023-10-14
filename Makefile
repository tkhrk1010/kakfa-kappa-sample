run:
	docker-compose up -d

down:
	docker-compose down

down-v:
	docker-compose down -v

run_sample:
	docker-compose exec -d long-term-store ruby mirror_to_postgres.rb
	sleep 5
	# without -d, you can see the output of the command
	docker-compose exec -d speed-layer ruby realtime_viewer.rb
	docker-compose exec event-producer ruby producer.rb 2
	docker-compose exec event-producer ruby producer.rb 7
	sleep 5
	docker-compose exec analytics-client ruby analytics_client.rb
	docker-compose exec speed-layer ruby recompute_from_storage.rb
	docker-compose exec postgres psql -U admin -d kafka_db -c "select * from messages;"