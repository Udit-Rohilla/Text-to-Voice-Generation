# Text-to-Voice-Generation
Built a production ready Rails API that converts text to speech using ElevenLabs. The system processes requests asynchronously with Sidekiq, stores audio on Cloudinary, tracks request states, handles errors gracefully, and applies rate limiting for safe and scalable usage.

# Voice Generation API with Rails

## Overview
This project is a Ruby on Rails API application that generates voice audio from text using the ElevenLabs API.  
Audio generation runs asynchronously using Sidekiq and results are stored in cloud storage with a public URL returned to the client.

## Tech Stack
- Ruby on Rails (API mode)
- PostgreSQL
- Sidekiq + Redis
- ElevenLabs Text to Speech API
- Cloudinary for audio storage
- RSpec for testing
- Railway for deployment

## Architecture
- POST request creates a VoiceRequest record
- Background job generates audio via ElevenLabs
- Audio uploaded to Cloudinary
- Client polls status endpoint
- URL returned when ready

## Environment Variables
ELEVENLABS_API_KEY
CLOUDINARY_URL
DATABASE_URL
REDIS_URL
SECRET_KEY_BASE

## API Endpoints

### POST /api/v1/voice_requests
Request
{
  "voice_request": {
    "input_text": "Hello world"
  }
}

Response
{
  "id": "uuid",
  "status": "pending"
}

### GET /api/v1/voice_requests/:id
Response
{
  "id": "uuid",
  "status": "success",
  "audio_url": "https://..."
}

### GET /api/v1/voice_requests
Returns recent history

## Running Locally
bundle install  
rails db:create db:migrate  
bundle exec sidekiq  
rails server  

## Testing
bundle exec rspec  

## Deployment
Deploy on Railway with two services
- Web service for Rails
- Worker service for Sidekiq
