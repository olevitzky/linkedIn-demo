Rails.application.routes.draw do
  namespace :api do
    resources :profiles do
      collection do
        get 'search'
      end
    end
  end
end
