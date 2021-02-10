Rails.application.routes.draw do
  devise_for :admins, :controllers => {
     :sessions => 'admins/sessions'
   }
 
   devise_scope :admin do
     get "dashboard", :to => "dashboard#index"
     get "dashboard/login", :to => "admins/sessions#new"
     post "dashboard/login", :to => "admins/sessions#create"
     get "dashboard/logout", :to => "admins/sessions#destroy"
   end
   
   namespace :dashboard do
     resources :users, only: [:index, :destroy]
     resources :major_categories 
     resources :categories, except: [:new]
     resources :products, except: [:show] do
        collection do 
         get  "import/csv", :to => "products#import"
         post "import/csv", :to => "products#import_csv"
         get  "import/csv_download", :to => "products#download_csv"
      end
     end
     resources :orders, only: [:index]
   end
   
  devise_for :users, :controllers => {
      :registrations => 'users/registrations',
      :sessions => 'users/sessions',
      :passwords => 'users/passwords',
      :confirmations => 'users/confirmations',
      :unlocks => 'users/unlocks'
  }
  
  devise_scope :user do
    root :to => "web#index"
    get "signup", :to => "users/registrations#new"
    get "verify", :to => "users/registrations#verify"
    get "login", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy"
  end
  
  resource :users, only: [:edit, :update] do
   collection do
     get "cart", :to => "shopping_carts#index"
     delete "cart", :to => "shopping_carts#destroy"
     post "cart/create", :to => "shopping_carts#create"
     get "mypage", :to => "users#mypage"
     put "mypage", :to => "users#update"
     get "mypage/edit", :to => "users#edit"
     get "mypage/edit_password", :to => "users#edit_password"
     delete "mypage/delete", :to => "users#destroy"
     get "mypage/address/edit", :to => "users#edit_address"
     put "mypage/password", :to => "users#update_password"
     get "mypage/favorite", :to => "users#favorite"
     get "mypage/cart_history", :to => "users#cart_history_index", :as => "mypage_cart_histories"
     get "mypage/cart_history/:num", :to => "users#cart_history_show", :as => "mypage_cart_history"      
   end

end
 
  resources :products do
      member do
          get :favorite
        end
   resources :reviews, only: [:create]
 end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
