require "rails_helper"

RSpec.describe VoiceRequest, type: :model do
  it "is valid with valid attributes" do
    voice_request = build(:voice_request)
    expect(voice_request).to be_valid
  end

  it "defines correct enum statuses" do
    expect(described_class.statuses.keys).to match_array(
      %w[pending processing success failed]
    )
  end

  it "provides enum predicate methods" do
    voice_request = build(:voice_request, status: :pending)

    expect(voice_request).to be_pending
    expect(voice_request).not_to be_processing
    expect(voice_request).not_to be_success
    expect(voice_request).not_to be_failed
  end

  it "can transition to processing" do
    voice_request = create(:voice_request)

    voice_request.processing!

    expect(voice_request.status).to eq("processing")
    expect(voice_request).to be_processing
  end
end
