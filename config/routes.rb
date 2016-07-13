require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  namespace :api do
    resources :profiles do
      collection do
        get 'search'
        get 'skills_search'
      end
    end
  end
end
