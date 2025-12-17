Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :voice_requests, only: [:create, :show, :index]
    end
  end
end
