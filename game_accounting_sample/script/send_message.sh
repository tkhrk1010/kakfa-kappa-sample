#!/bin/bash
# chmod +x script/send_message.sh
# ./send_message.sh

# DockerのKafkaコンテナ名
KAFKA_CONTAINER_NAME="game_accounting_sample-kafka-1"

# Kafkaのブローカーアドレス
BROKER="game_accounting_sample-kafka-1:9092"

# トピック名
TOPIC="game"

# Timestamp (YYYY-MM-DD HH:MM:SS)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

GAME_ID="game_1"

# 第一引数が1のとき、actionをapplyにする
if [ "$1" -eq 1 ]; then
  ACTION="apply"
  USER_ID=$(uuidgen)
  MESSAGE='{"action": "'$ACTION'", "user_id": "'$USER_ID'", "game_id": "'$GAME_ID'", "timestamp": "'$TIMESTAMP'"}'
# 引数が2のとき、actionをuseにする
elif [ "$1" -eq 2 ]; then
  ACTION="use"
  GAME_APPLICATION_ID=$2
  MESSAGE='{"action": "'$ACTION'", "game_application_id": "'$GAME_APPLICATION_ID'", "game_id": "'$GAME_ID'", "timestamp": "'$TIMESTAMP'"}'
# 引数が3のとき、actionをcancelにする
elif [ "$1" -eq 3 ]; then
  ACTION="cancel"
  GAME_APPLICATION_ID=$2
  MESSAGE='{"action": "'$ACTION'", "game_application_id": "'$GAME_APPLICATION_ID'", "game_id": "'$GAME_ID'", "timestamp": "'$TIMESTAMP'"}'
fi

# Dockerを使用してKafkaコンテナ内でkafka-console-producerを実行
echo $MESSAGE | docker exec -i $KAFKA_CONTAINER_NAME kafka-console-producer --broker-list $BROKER --topic $TOPIC
