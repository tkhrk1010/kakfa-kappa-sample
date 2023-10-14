require 'kafka'
require 'json'

# Kafka setup
kafka = Kafka.new(["kafka-kappa-sample-kafka-1:9092"], client_id: "realtime-viewer")
consumer = kafka.consumer(group_id: "realtime-viewer-group")
consumer.subscribe("sample-topic")

# Fetch and display real-time data from Kafka
consumer.each_message do |message|
  data = JSON.parse(message.value)
  puts "Received message: #{data['message']} at #{data['event_timestamp']}"
end
