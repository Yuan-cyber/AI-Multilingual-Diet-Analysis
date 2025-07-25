require 'sequel'

# connect to sqlite database
DB = Sequel.connect('sqlite://app.db')

# create users table
DB.create_table? :users do
  primary_key :id
  String :username, null: false, unique: true
  String :password_hash, null: false
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
  DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
end

puts "Database tables created successfully!" 