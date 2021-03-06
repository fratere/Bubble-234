Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ActionCable.server => '/cable'

  root to: "cocktails#index"

  devise_for :users, :path_names => {:sign_in => 'login', :sign_out => 'logout'}, :controllers => { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks'}

  get 'users/results'

  get 'cocktails/random', to: 'cocktails#random', as: 'random'
  get 'cocktails/results'

  resources :conversations, only: [:index, :create] do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end


  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships, only: [:create, :destroy]

  resources :cocktails do

    put :favorite, on: :member

    resources :reviews do
      member do
        post 'like'
        delete 'dislike'
      end
    end

  end

end
