require 'sidekiq/web'
RestaurantServer::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v1 do
      # resources :categories, :except => [:index]
      resources :categories, :only => [:index]
      resources :types, :only => [:index] do
        collection do
          get 'type_area_ship'
        end
      end
      resources :areas, :only => [:index]
      resources :area_categoryship, :only => [:index]
      resources :restaurants, :only => [:index, :show]
      resources :areas, :only => [:index]
      resources :notes, :only => [:index, :show]
      resources :recommands, :only => [:create]
    end
  end

end
