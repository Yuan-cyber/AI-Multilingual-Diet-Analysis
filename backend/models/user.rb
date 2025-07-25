require 'sequel'
require 'bcrypt'

class User < Sequel::Model
  include BCrypt
  
  # set password
  def password=(new_password)
    self.password_hash = Password.create(new_password)
  end
  
  # password validation
  def authenticate(password)
    BCrypt::Password.new(self.password_hash) == password
  end
  
  # find user by username
  def self.find_by_username(username)
    where(username: username).first
  end
end 