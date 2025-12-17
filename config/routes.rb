Rails.application.routes.draw do
  root to: proc { [200, { "Content-Type" => "application/json" }, [{ status: "ok", service: "text-to-voice-generation" }.to_json]] }

  get "/health", to: proc { [200, { "Content-Type" => "application/json" }, ["OK"]] }

  namespace :api do
    namespace :v1 do
      resources :voice_requests, only: [:create, :show, :index]
    end
  end
end
