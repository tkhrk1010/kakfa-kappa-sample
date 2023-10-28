#!/bin/bash

KAFKA_HOST="game_accounting_sample-kafka-1"
KAFKA_PORT=9092

# timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "$TIMESTAMP Waiting for Kafka to be ready..."

until nc -z $KAFKA_HOST $KAFKA_PORT; do
    sleep 1
done

echo "$TIMESTAMP Kafka is ready."

ruby app.rb
