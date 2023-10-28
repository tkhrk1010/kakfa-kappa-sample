# Usage: ruby app.rb
# Description: This is a sample application that consumes messages from Kafka and updates the database.

# This is needed to ensure that the logs from the application are outputted immediately instead of being buffered.
$stdout.sync = true

require 'pg'
require 'kafka'
require_relative 'game'

puts "Listening to game kafka topic"

kafka = Kafka.new(["game_accounting_sample-kafka-1:9092"])
consumer = kafka.consumer(group_id: "game-consumer-group")
consumer.subscribe("game")

consumer.each_message do |message|
  puts "Received message: #{message.value}"
  data = JSON.parse(message.value)
  game = Game.new
  if data["action"] == "apply"
    game.apply(data["user_id"])
  elsif data["action"] == "use"
    game.use(data["game_application_id"])
  elsif data["action"] == "cancel"
    if game.usage_status(data["game_application_id"]) == "before_used"
      game.cancel_before_use(data["game_application_id"])
    else
      game.cancel_after_use(data["game_application_id"])
    end
  else
    puts "unknown action"
  end
end

puts "stop listening kafka"