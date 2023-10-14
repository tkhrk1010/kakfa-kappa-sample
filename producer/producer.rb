require 'kafka'

kafka = Kafka.new(["kafka:9092"])

producer = kafka.producer

message = ARGV[0]
producer.produce(message, topic: "sample-topic")
producer.deliver_messages

puts "Procuced message: #{message}"