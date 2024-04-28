require 'httparty'

class Llm
  include HTTParty
  default_timeout 5000
  base_uri ENV.fetch('LLM_URL')

  def self.call(payload)
    response = post('/generate', body: payload.to_json, headers: { 'Content-Type' => 'application/json' })
    if response.success?
      response.parsed_response
    else
      { error: "Failed to encode text: #{response.message}" }
    end
  end

end
