# Usage: ruby credit.rb
# Description: This consumes credit-related messages from Kafka and updates the credit database.

# Ensure logs are outputted immediately.
$stdout.sync = true

require 'pg'
require 'kafka'
require_relative 'credit'  # Assuming you've separated the Credit class to a file called credit_class.rb

puts "Listening to credit kafka topic"

kafka = Kafka.new(["game_accounting_sample-kafka-1:9092"])
consumer = kafka.consumer(group_id: "credit-consumer-group")
consumer.subscribe("credit")

consumer.each_message do |message|
  puts "Received credit message: #{message.value}"
  data = JSON.parse(message.value)
  credit = Credit.new
  credit.create(data["game_application_id"], data["timestamp"])
end

puts "Stop listening to credit kafka topic"
