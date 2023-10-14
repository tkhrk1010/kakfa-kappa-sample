run_sample:
	docker-compose exec ruby-producer ruby producer.rb "sample_message_$(shell date +'%Y-%m%d-%H-%M-%S' | sed 's/...$$//')"
	sleep 3
	docker-compose exec ruby-producer ruby producer.rb "sample_message_$(shell date +'%Y-%m%d-%H-%M-%S' | sed 's/...$$//')"
	docker-compose exec ruby-consumer ruby consumer.rb
	docker-compose exec postgres psql -U admin -d kafka_db -c "select * from messages;"