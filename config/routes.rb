Rails.application.routes.draw do
  root to: proc { [200, {}, ["Text to Voice Generation API is running"]] }

  get "/health", to: proc { [200, {}, ["OK"]] }

  namespace :api do
    namespace :v1 do
      resources :voice_requests, only: [:create, :show, :index]
    end
  end
end
