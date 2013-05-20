RestaurantServer::Application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      # resources :categories, :except => [:index]
      resources :categories, :only => [:index]
      resources :areas, :only => [:index]
      resources :area_categoryship, :only => [:index]
      resources :restaurants, :only => [:index, :show]
      resources :areas, :only => [:index]
      resources :notes, :only => [:index, :show]
    end
  end

end
