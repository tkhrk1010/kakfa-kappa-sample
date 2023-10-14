require 'kafka'
require 'json'

kafka = Kafka.new(["kafka:9092"])
producer = kafka.producer

message = ARGV[0]
# 20230129153500832のような形式でイベント発生のタイムスタンプを追加
event_timestamp = Time.now.strftime("%Y%m%d%H%M%S%L").to_i

# JSON形式でメッセージを作成
data = {
  message: message,
  event_timestamp: event_timestamp
}.to_json

producer.produce(data, topic: "sample-topic")
producer.deliver_messages

puts "Produced message: #{data}"
