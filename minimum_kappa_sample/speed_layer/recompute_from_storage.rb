# This is a basic example. The actual logic for re-computation will depend on the use-case.
require 'pg'

# PostgreSQL connection
conn = PG.connect(host: "postgres", dbname: "kafka_db", user: "admin", password: "password")

# Fetch all data
result = conn.exec("SELECT * FROM messages")

# Re-compute based on the data (example: sum of all values)
sum = 0
result.each do |row|
  sum += row['value'].to_i
end

puts "Total Sum: #{sum}"
