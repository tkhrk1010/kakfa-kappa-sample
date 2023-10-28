# Usage: ruby app.rb
# Description: This is a sample application that consumes messages from Kafka and updates the database.

# This is needed to ensure that the logs from the application are outputted immediately instead of being buffered.
$stdout.sync = true

require 'pg'
require 'kafka'

class Game

  USED = "used"
  BEFORE_USED = "before_used"

  def initialize
    @conn = PG.connect(host: "postgres", dbname: "game_db", user: "db_user", password: "db_password")
  end

  def apply(user_id)
    puts "user_id: #{user_id} applied game"
    current_timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    uuid = SecureRandom.uuid
    res = @conn.exec("INSERT INTO game_application (id, user_id, applied_at, created_at, updated_at) VALUES ('#{uuid}', '#{user_id}', '#{current_timestamp}', '#{current_timestamp}', '#{current_timestamp}')")
  end

  def use(game_application_id)
    puts "game_application_id: #{game_application_id} used"
    current_timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    uuid = SecureRandom.uuid
    res = @conn.exec("INSERT INTO game_usage (id, game_application_id, used_at, created_at, updated_at) VALUES ('#{uuid}', '#{game_application_id}', '#{current_timestamp}', '#{current_timestamp}', '#{current_timestamp}')")
  end

  def cancel_before_use(game_application_id)
    puts "game_application_id: #{game_application_id} canceled game before use"
    current_timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    uuid = SecureRandom.uuid
    res = @conn.exec("INSERT INTO game_cancel_before_use (id, game_application_id, canceled_at, created_at, updated_at) VALUES ('#{uuid}', '#{game_application_id}', '#{current_timestamp}', '#{current_timestamp}', '#{current_timestamp}')")
  end

  def cancel_after_use(game_application_id)
    puts "game_application_id: #{game_application_id} canceled game after use"
    current_timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    uuid = SecureRandom.uuid
    res = @conn.exec("INSERT INTO game_cancel_after_use (id, game_application_id, canceled_at, created_at, updated_at) VALUES ('#{uuid}', '#{game_application_id}', '#{current_timestamp}', '#{current_timestamp}', '#{current_timestamp}')")
  end

  def usage_status(game_application_id)
    puts "check game_application_id: #{game_application_id} usage status"
    usage = @conn.exec("SELECT 1 FROM game_usage WHERE game_application_id = '#{game_application_id}'")
    if usage.count > 0
      return USED
    else
      return BEFORE_USED
    end
  end
end

puts "lesten kafka"

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