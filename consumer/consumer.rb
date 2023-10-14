require 'kafka'
require 'pg'

# PostgreSQL connection
conn = PG.connect(host: "postgres", dbname: "kafka_db", user: "admin", password: "password")

# Kafka setup
kafka = Kafka.new(["kafka-kappa-sample-kafka-1:9092"], client_id: "ruby-consumer")
consumer = kafka.consumer(group_id: "ruby-consumer-group")
consumer.subscribe("sample-topic")

begin
  Timeout::timeout(10) do
    consumer.each_message do |message|
      puts "Received message: #{message.value}"
      conn.exec("INSERT INTO messages (value) VALUES ('#{message.value}')")
    end
  end
rescue Timeout::Error
  puts "10 seconds have passed. Exiting..."
ensure
  # Close the connection to Kafka
  consumer.stop
end