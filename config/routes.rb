Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    jsonapi_resources :sleep_records, only: [:index]
    jsonapi_resources :timesheets, only: [:index] do
      collection do
        post 'clock-in'
        post 'clock-out'
      end
    end
  end
end
