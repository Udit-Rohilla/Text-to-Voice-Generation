class VoiceRequest < ApplicationRecord
  enum status: {
    pending: 'pending',
    processing: 'processing',
    success: 'success',
    failed: 'failed'
  }

  validates :input_text, presence: true, length: { maximum: 5000 }
end
