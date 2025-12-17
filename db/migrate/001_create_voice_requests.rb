class CreateVoiceRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :voice_requests, id: :uuid do |t|
      t.text :input_text, null: false
      t.string :status, default: 'pending'
      t.string :audio_url
      t.text :error_message
      t.jsonb :audio_metadata
      t.timestamps
    end
  end
end
