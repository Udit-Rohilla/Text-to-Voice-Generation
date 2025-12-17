require "rails_helper"

RSpec.describe GenerateVoiceJob, type: :job do
  let(:voice_request) { create(:voice_request) }

  before do
    allow(ElevenLabsTtsService).to receive(:generate)
      .and_return("fake_audio_binary")

    allow(Cloudinary::Uploader).to receive(:upload)
      .and_return({
        "secure_url" => "https://cloudinary.com/audio.mp3"
      })
  end

  it "processes voice request successfully" do
    described_class.new.perform(voice_request.id)

    voice_request.reload

    expect(voice_request.status).to eq("success")
    expect(voice_request.audio_url).to eq("https://cloudinary.com/audio.mp3")
    expect(voice_request.audio_metadata).to be_present
  end

  it "marks request as failed if an error occurs" do
    allow(ElevenLabsTtsService).to receive(:generate)
      .and_raise(StandardError.new("ElevenLabs error"))

    described_class.new.perform(voice_request.id)

    voice_request.reload

    expect(voice_request.status).to eq("failed")
    expect(voice_request.error_message).to eq("ElevenLabs error")
  end
end
