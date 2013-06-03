require 'sidekiq/web'
RestaurantServer::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v1 do
      # resources :categories, :except => [:index]
      resources :categories, :only => [:index] do
        collection do
          get 'rake_categories'
        end
      end
      resources :types, :only => [:index] do
        collection do
          get 'type_area_ship'
        end
      end
      resources :areas, :only => [:index]
      resources :area_categoryship, :only => [:index]
      resources :restaurants, :only => [:index, :show] do
        collection do
          get 'select_restaurants'
          get 'around_restaurates'
          get 'second_restaurants'
        end
      end
      resources :areas, :only => [:index]
      resources :rank_categories, :only => [:index]
      resources :second_categories, :only => [:index]
      resources :notes, :only => [:index, :show] do
        collection do
          get 'select_notes'
          get 'second_notes'
        end
      end
      resources :recommands, :only => [:create]
    end
  end

end
