# Depending on the analytics needs, this code can be elaborated. Here, it's just a representation.
require 'pg'

# PostgreSQL connection
conn = PG.connect(host: "postgres", dbname: "kafka_db", user: "admin", password: "password")

# Fetch data for analytics
result = conn.exec("SELECT * FROM messages")

# Basic analytics: Count of records
puts "Total Records: #{result.count}"
