# Usage: ruby app.rb
# Description: This is a sample application that consumes messages from Kafka and updates the database.

# This is needed to ensure that the logs from the application are outputted immediately instead of being buffered.
$stdout.sync = true

require 'pg'
require 'kafka'

class Service
  def initialize
    @conn = PG.connect(host: "postgres", dbname: "service_db", user: "postgres_service_user", password: "password")
  end

  def apply_service(user_id)
    # Implement logic to apply for a service for a user
  end

  def update_status_to_in_use(user_id)
    res = @conn.exec("SELECT * FROM before_use WHERE user_id = '#{user_id}'")
    puts "update #{user_id} status to in_use"
    # Other implementation details...
  end

  def cancel_service(user_id, status)
    # Implement logic to cancel a service for a user based on the status
  end
end

puts "start"

kafka = Kafka.new(["service_accounting_sample-kafka-1:9092"])

consumer = kafka.consumer(group_id: "service-consumer-group")

consumer.subscribe("service_apply")

consumer.each_message do |message|
  puts "Received message: #{message.value}"
  data = JSON.parse(message.value)
  service = Service.new
  if data["action"] == "apply"
    service.apply_service(data["user_id"])
  elsif data["action"] == "in_use"
    service.update_status_to_in_use(data["user_id"])
  elsif data["action"] == "cancel"
    service.cancel_service(data["user_id"], data["status"])
  end
end

puts "finished"