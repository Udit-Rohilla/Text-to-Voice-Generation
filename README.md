# Text to Voice Generation

A production ready Ruby on Rails API that converts text into speech using the ElevenLabs Text to Speech API.  
The system processes requests asynchronously using Sidekiq, stores generated audio on Cloudinary, tracks generation status, handles failures gracefully, plays generated audio in the browser, view past generation history and delete previously generated voice records.

---

## Overview

This project is a Ruby on Rails API application designed to generate voice audio from input text.

Instead of blocking client requests during audio generation, the system persists each request, processes it asynchronously in the background and allows clients to poll for status updates until the audio is ready.

This approach keeps the API responsive, reliable and scalable under load.

---

## Tech Stack

- Ruby on Rails 7 in API mode  
- PostgreSQL for persistent storage  
- Sidekiq with Redis for background job processing  
- ElevenLabs Text to Speech API  
- Cloudinary for audio storage and delivery  
- RSpec for automated testing  
- Railway for deployment  

---

## Architecture

- Client sends a POST request with input text  
- API creates a VoiceRequest record with status set to pending  
- A Sidekiq background job processes the request  
- ElevenLabs API generates the audio  
- Audio file is uploaded to Cloudinary  
- VoiceRequest is updated with the audio URL and final status  
- Client polls a status endpoint until processing completes  

This architecture ensures heavy processing does not block API request threads.

---

## Environment Variables

The following environment variables are required to run the application.

- ELEVENLABS_API_KEY
- CLOUDINARY_URL
- DATABASE_URL
- REDIS_URL
- SECRET_KEY_BASE
- ELEVENLABS_VOICE_ID

---

## API Endpoints

### Create a voice request

POST `/api/v1/voice_requests`

Request body

```json
{
  "voice_request": {
    "input_text": "Hello world"
  }
}
```

Response

```json
{
  "id": "uuid",
  "status": "pending"
}
```

---

### Fetch a single voice request

GET `/api/v1/voice_requests/:id`

Response

```json
{
  "id": "uuid",
  "status": "completed",
  "audio_url": "https://..."
}
```

---

### Fetch recent voice requests

GET `/api/v1/voice_requests`

Returns a list of recent voice generation requests along with their current status.

---

## Running Locally

### Start backend services

```bash
redis-server
bin/rails server
bundle exec sidekiq
```

---

### Start frontend

```bash
cd voice-ui
npm run dev
```

Open the application at

```
http://localhost:5173
```

---

## Testing

Automated tests cover models and background job behavior.

```bash
bundle exec rspec
```

---

## Deployment

The application is deployed on Railway using two separate services.

- A web service running the Rails API  
- A worker service running Sidekiq  

This separation allows background processing to scale independently from API traffic.

---

## Design Decisions

### Asynchronous Processing

Audio generation is a time consuming operation.  
Using Sidekiq allows the API to remain fast and responsive while heavy processing happens in the background.

---

### State Driven Request Lifecycle

Each request moves through clear states such as pending, processing, completed and failed.  
This makes the system easier to reason about, debug and monitor.

---

### Cloudinary for Audio Storage

Generated audio files are stored in Cloudinary instead of on the application server.  
This avoids disk management issues, enables CDN backed delivery and keeps the API stateless.

---

### Separation of Concerns

Controllers focus on request validation and response formatting.  
Business logic lives in models and background jobs, making the codebase easier to maintain and test.

---

### Error Handling and Stability

- External API failures are captured and reflected in request state  
- Background job failures do not impact API availability  
- Invalid input is rejected early using validations  
- Rate limiting protects the API from abuse  
