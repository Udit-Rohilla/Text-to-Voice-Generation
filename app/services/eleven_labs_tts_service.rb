require 'faraday'

class ElevenLabsTtsService
  BASE_URL = 'https://api.elevenlabs.io/v1/text-to-speech'

  def self.generate(text)
    voice_id = ENV.fetch('ELEVENLABS_VOICE_ID')

    conn = Faraday.new do |f|
      f.adapter Faraday.default_adapter
    end

    response = conn.post("#{BASE_URL}/#{voice_id}") do |req|
      req.headers['xi-api-key'] = ENV.fetch('ELEVENLABS_API_KEY')
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'audio/mpeg'

      req.body = {
        text: text,
        model_id: 'eleven_turbo_v2'
      }.to_json
    end

    unless response.success?
      raise "ElevenLabs error #{response.status}: #{response.body}"
    end

    response.body
  end
end
