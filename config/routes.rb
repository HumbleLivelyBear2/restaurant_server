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
          get 'area_restaurants'
          get 'category_restaurants'
          get 'type_restaurants'
          get 'rank_restaurants'
          get 'search'
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

      resources :users, :only => [:create] do
        collection do
          put 'update_looked_restaurants'
          put 'update_looked_notes'
          put 'update_collect_restaurants'
          put 'update_collect_notes'
        end
      end
    end
  end

end
