require 'pg'
require 'kafka'
require 'json'

class Game

  USED = "used"
  BEFORE_USED = "before_used"

  def initialize
    @conn = PG.connect(host: "postgres", dbname: "game_db", user: "db_user", password: "db_password")
    @kafka = Kafka.new(["game_accounting_sample-kafka-1:9092"])
    @producer = @kafka.producer
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

    puts "produce credit event"
    # Produce a credit event to Kafka
    credit_event = { action: "credit", game_application_id: game_application_id, timestamp: current_timestamp }.to_json
    @producer.produce(credit_event, topic: "credit")
    @producer.deliver_messages
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
