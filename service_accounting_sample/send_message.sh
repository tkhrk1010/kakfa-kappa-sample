#!/bin/bash
# chmod +x send_message.sh
# ./send_message.sh

# DockerのKafkaコンテナ名
KAFKA_CONTAINER_NAME="service_accounting_sample-kafka-1"

# Kafkaのブローカーアドレス
BROKER="service_accounting_sample-kafka-1:9092"

# トピック名
TOPIC="service_apply"

# Timestamp (YYYY-MM-DD HH:MM:SS)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# メッセージの内容
MESSAGE='{"action": "in_use", "user_id": "user_1", "service_id": "service_1", "timestamp": "'$TIMESTAMP'"}'

# Dockerを使用してKafkaコンテナ内でkafka-console-producerを実行
echo $MESSAGE | docker exec -i $KAFKA_CONTAINER_NAME kafka-console-producer --broker-list $BROKER --topic $TOPIC
