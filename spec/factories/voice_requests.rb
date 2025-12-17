FactoryBot.define do
  factory :voice_request do
    input_text { "Test voice generation" }
    status { "pending" }
    audio_url { nil }
    audio_metadata { nil }
    error_message { nil }
  end
end
