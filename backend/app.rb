require 'sinatra'
require 'sinatra/cors'
require 'json'
require 'sequel'
require 'dotenv/load'

# database connection
DB = Sequel.connect('sqlite://app.db')

# load models and services
require_relative 'models/user'
require_relative 'services/auth_service'
require_relative 'services/gemini_service'

# CORS configuration
set :allow_origin, "*"
set :allow_methods, "GET,HEAD,POST"
set :allow_headers, "content-type,if-modified-since,authorization"
set :expose_headers, "location,link"

# JSON response helper method
def json_response(data, status = 200)
  content_type :json
  status status
  data.to_json
end

def json_error(message, status = 400)
  json_response({ error: message }, status)
end

# authentication middleware, validate JWT token, if token is invalid, return 401 error
def authenticate!
  @current_user = AuthService.current_user(request)
  halt 401, json_error('Unauthorized', 401) unless @current_user
end

# health check
get '/' do
  json_response({ message: 'AI Food Translator API', status: 'running' })
end

# user login
post '/api/login' do
  data = JSON.parse(request.body.read)
  username = data['username']
  password = data['password']

  user = User.find_by_username(username)
  if user && user.authenticate(password)
    token = AuthService.generate_user_token(user)
    json_response({
      token: token,
      user: { id: user.id, username: user.username }
    })
  else
    json_error('Invalid username or password', 401)
  end
rescue JSON::ParserError
  json_error('Invalid JSON')
end

post '/api/register' do
  data = JSON.parse(request.body.read)
  username = data['username']
  password = data['password']

  # validate username format
  if username.nil? || username.strip.empty?
    halt 400, json_error('Username cannot be empty')
  end

  # check if username is already registered
  if User.find_by_username(username)
    halt 400, json_error('Username already registered')
  end

  # validate password length
  if password.nil? || password.length < 6
    halt 400, json_error('Password too short (min 6 chars)')
  end

  # create new user, and assign username and password to it
  user = User.new(username: username)
  user.password = password
  if user.save
    json_response({ message: 'Register success' })
  else
    json_error('Register failed')
  end
end

# AI food analysis
post '/api/analyze' do
  # authenticate the user
  authenticate!
  
  data = JSON.parse(request.body.read)
  text = data['text']
  target_language = data['target_language'] || 'en'
  
  # call gemini api
  result = GeminiService.analyze_food(text, target_language)
  
  if result[:error]
    json_error(result[:error])
  else
    json_response({
      result: result[:result]
    })
  end
rescue JSON::ParserError
  json_error('Invalid JSON')
rescue => e
  json_error("Server error: #{e.message}", 500)
end

# supported languages list
get '/api/languages' do
  json_response({ 
    languages: GeminiService::SUPPORTED_LANGUAGES 
  })
end

# start server
if __FILE__ == $0
  set :port, 4567
  set :bind, '0.0.0.0'
  puts "🚀 AI Food Translator running on http://localhost:4567"
end 