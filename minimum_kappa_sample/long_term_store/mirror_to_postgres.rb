require 'kafka'
require 'pg'
require 'json'

# PostgreSQL connection
conn = PG.connect(host: "postgres", dbname: "kafka_db", user: "admin", password: "password")

# Kafka setup
kafka = Kafka.new(["kafka-kappa-sample-kafka-1:9092"], client_id: "ruby-consumer")
consumer = kafka.consumer(group_id: "ruby-consumer-group")
consumer.subscribe("sample-topic")

# Mirror events to long-term storage (DB in this case)
consumer.each_message do |message|
  data = JSON.parse(message.value)
  process_timestamp = Time.now.to_i

  # Save to DB (Master Data)
  conn.exec("INSERT INTO messages (value, event_timestamp, process_timestamp) VALUES ('#{data['message']}', '#{data['event_timestamp']}', '#{process_timestamp}')")
end
