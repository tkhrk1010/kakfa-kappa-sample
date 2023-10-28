require 'pg'
require 'kafka'

class Credit
  def initialize
    @conn = PG.connect(host: "postgres", dbname: "game_db", user: "db_user", password: "db_password")
  end

  def create(game_application_id, incurred_at)
    puts "Creating credit for game_application_id: #{game_application_id}"
    current_timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    uuid = SecureRandom.uuid
    res = @conn.exec("INSERT INTO credits (id, game_application_id, incurred_at, created_at, updated_at) VALUES ('#{uuid}', '#{game_application_id}', '#{incurred_at}', '#{current_timestamp}', '#{current_timestamp}')")
  end
end