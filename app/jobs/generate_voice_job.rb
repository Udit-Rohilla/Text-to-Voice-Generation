class GenerateVoiceJob
  include Sidekiq::Worker

  def perform(id)
    vr = VoiceRequest.find(id)
    vr.update!(status: "processing")

    audio = ElevenLabsTtsService.generate(vr.input_text)

    Rails.logger.info "ElevenLabs audio class: #{audio.class}"
    Rails.logger.info "ElevenLabs audio bytesize: #{audio.bytesize}"

    upload = Cloudinary::Uploader.upload(
      "data:audio/mpeg;base64,#{Base64.strict_encode64(audio)}",
      resource_type: :raw,
      format: "mp3"
    )

    vr.update!(
      status: "success",
      audio_url: upload["secure_url"],
      audio_metadata: { size: audio.bytesize }
    )
  rescue => e
    Rails.logger.error "GenerateVoiceJob failed: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n")

    vr.update!(
      status: "failed",
      error_message: e.message
    )
  end
end
