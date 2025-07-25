require 'faraday'
require 'json'

class GeminiService
  API_KEY = ENV['GEMINI_API_KEY'] || 'gemini_api_key'
  BASE_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent'
  
  SUPPORTED_LANGUAGES = {
    'en' => 'English',
    'zh' => '中文',
    'ja' => '日本語',
    'fr' => 'Français',
    'de' => 'Deutsch',
    'es' => 'Español',
    'ko' => '한국어',
    'it' => 'Italiano'
  }.freeze

  def self.analyze_food(text, target_language)
    return { error: 'Please enter food description (max 500 characters)' } unless validate_input(text)
    return { error: 'Unsupported language' } unless SUPPORTED_LANGUAGES.key?(target_language)

    clean_text = sanitize_input(text)
    prompt = build_simple_prompt(clean_text, target_language)

    response = call_gemini_api(prompt)

    if response['error']
      { error: response['error'] }
    else
      content = response.dig('candidates', 0, 'content', 'parts', 0, 'text')
      { result: content || 'fail to analyze, please try again' }
    end
  end

  private
  
  # input validation - prevent prompt injection
  def self.validate_input(text)
    return false if text.nil? || text.empty?
    return false if text.length > 500
    
    # detect suspicious patterns
    suspicious_patterns = [
      /忽略.*指令/i,
      /ignore.*instruction/i,
      /system.*prompt/i,
      /新任务/i,
      /new.*task/i,
      /---+/,
      /\n\n+/
    ]
    
    suspicious_patterns.none? { |pattern| text.match?(pattern) }
  end

  # clean input text
  def self.sanitize_input(text)
    text.strip.gsub(/[^\w\s\u4e00-\u9fff\u3040-\u309f\u30a0-\u30ff.,!?()-]/, '')
  end

  # build prompt
  def self.build_simple_prompt(text, target_language)
    language_name = SUPPORTED_LANGUAGES[target_language]
    
    <<~PROMPT
      You are a professional food nutrition expert.

      Analyze the input and give calorie analysis for each food item plus total calories if multiple items.  
      Output **only** in #{language_name}.  
      Do not use any other language or extra symbols. 

      User input: #{text}

    PROMPT
  end
  
  # call Gemini API
  def self.call_gemini_api(prompt)
    conn = Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :json
      faraday.response :json
      faraday.adapter Faraday.default_adapter
    end
    
    request_body = {
      contents: [{
        parts: [{
          text: prompt
        }]
      }]
    }
    
    begin
      response = conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.params['key'] = API_KEY
        req.body = request_body
      end
      
      if response.success?
        response.body
      else
        { 'error' => "API request failed: #{response.status}" }
      end
    rescue => e
      { 'error' => "Network error: #{e.message}" }
    end
  end
end
