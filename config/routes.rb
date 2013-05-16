RestaurantServer::Application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      # resources :categories, :except => [:index]
      resources :categories, :only => [:index]
      resources :restaurants, :only => [:index]
      resources :areas, :only => [:index]
    end
  end

end
