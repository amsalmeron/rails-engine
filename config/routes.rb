Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/items/find_all',  to: 'search_items#index'
      get '/items/find',  to: 'search_items#show'

      get '/merchants/find_all',  to: 'search_merchants#index'
      get '/merchants/find',  to: 'search_merchants#show'

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end

      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get '/merchant', to: 'item_merchant#index'
      end

    end
  end
end
