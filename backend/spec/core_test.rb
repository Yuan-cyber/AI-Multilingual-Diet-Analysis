require 'rack/test'
require 'json'
require_relative '../app'

class CoreIntegrationTest
  include Rack::Test::Methods
  
  def app
    app = Sinatra::Application
    app.set :protection, false
    app
  end
  
  def run_tests
    puts "Running Core Integration Tests..."
    
    # generate random test username and password
    @test_username = "testuser_#{Time.now.to_i}_#{rand(1000)}"
    @test_password = "testpass"
    
    # run all tests
    test_user_registration
    test_user_login
    test_invalid_login
    test_authenticated_analysis
    test_unauthenticated_analysis
    test_invalid_token_analysis
    
  end
  
  private
  
  # unified request method, add necessary headers
  def json_request(method, path, data = {}, headers = {})
    default_headers = {
      'CONTENT_TYPE' => 'application/json',
      'HTTP_HOST' => 'localhost:4567'
    }
    
    send(method, path, data.to_json, default_headers.merge(headers))
  end
  
  # assert response
  def assert_response(expected_status, error_message)
    unless last_response.status == expected_status
      puts "❌ #{error_message}: #{last_response.status} - #{last_response.body}"
      raise error_message
    end
    JSON.parse(last_response.body)
  end
  
  # test user registration
  def test_user_registration
    print "Testing user registration... "
    
    json_request(:post, '/api/register', {
      username: @test_username, 
      password: @test_password
    })
    
    response = assert_response(200, "User registration failed")
    raise "Invalid response" unless response['message'] == 'Register success'
    
    puts "✅"
  end

  # test user login
  def test_user_login
    print "Testing user login... "
    
    json_request(:post, '/api/login', {
      username: @test_username, 
      password: @test_password
    })
    
    response = assert_response(200, "User login failed")
    @token = response['token']
    
    raise "No token received" if @token.nil?
    raise "Invalid user data" unless response['user']['username'] == @test_username
    
    puts "✅"
  end

  # test invalid login
  def test_invalid_login
    print "Testing invalid login rejection... "
    
    json_request(:post, '/api/login', {
      username: @test_username,
      password: 'wrongpassword'
    })
    
    response = assert_response(401, "Should reject invalid credentials")
    raise "Wrong error message" unless response['error'] == 'Invalid username or password'
    
    puts "✅"
  end

  # test authenticated analysis
  def test_authenticated_analysis
    print "Testing authenticated food analysis... "
    
    json_request(:post, '/api/analyze', {
      text: 'apple', 
      target_language: 'zh'
    }, {
      'HTTP_AUTHORIZATION' => "Bearer #{@token}"
    })
    
    response = assert_response(200, "Authenticated analysis failed")
    raise "No analysis result" if response['result'].nil?
    
    puts "✅"
  end

  # test unauthenticated analysis
  def test_unauthenticated_analysis
    print "Testing unauthenticated analysis rejection... "
    
    json_request(:post, '/api/analyze', {
      text: 'apple', 
      target_language: 'zh'
    })
    
    response = assert_response(401, "Should reject unauthenticated request")
    raise "Wrong error message" unless response['error'] == 'Unauthorized'
    
    puts "✅"
  end

  # test invalid token analysis
  def test_invalid_token_analysis
    print "Testing invalid token analysis rejection... "
    
    json_request(:post, '/api/analyze', {
      text: 'apple', 
      target_language: 'zh'
    }, {
      'HTTP_AUTHORIZATION' => "Bearer invalid_token_here"
    })
    
    response = assert_response(401, "Should reject invalid token")
    raise "Wrong error message" unless response['error'] == 'Unauthorized'
    
    puts "✅"
  end
end

# run tests
if __FILE__ == $0
  CoreIntegrationTest.new.run_tests
end 