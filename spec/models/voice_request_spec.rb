require "rails_helper"

RSpec.describe VoiceRequest, type: :model do
  it "is valid with valid attributes" do
    vr = build(:voice_request)
    expect(vr).to be_valid
  end

  it "has correct enum statuses" do
    vr = build(:voice_request)
    expect(vr).to respond_to(:pending)
    expect(vr).to respond_to(:processing)
    expect(vr).to respond_to(:success)
    expect(vr).to respond_to(:failed)
  end

  it "can transition to processing" do
    vr = create(:voice_request)
    vr.processing!
    expect(vr.status).to eq("processing")
  end
end
