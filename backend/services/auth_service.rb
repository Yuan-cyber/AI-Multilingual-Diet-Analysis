require 'jwt'

class AuthService
  SECRET_KEY = ENV['JWT_SECRET'] || 'jwt_secret_key'
  
  # generate JWT token
  def self.encode_token(payload)
    payload[:exp] = Time.now.to_i + 24 * 3600 # 24 hours expired
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  # generate user token
  def self.generate_user_token(user)
    encode_token({ user_id: user.id, username: user.username })
  end
  
  # validate and decode token
  def self.decode_token(token)
    begin
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
      decoded[0] # return payload user information
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      nil
    end
  end
  
  # get current user from request header
  def self.current_user(request)
    auth_header = request.env['HTTP_AUTHORIZATION']
    return nil unless auth_header
    
    token = auth_header.split(' ').last
    payload = decode_token(token)
    return nil unless payload
    
    # use [] operator to ensure return single object
    User[payload['user_id']]
  rescue
    nil
  end
  
end 