Rails.application.routes.draw do
  resources :teams, shallow: true do
    post 'invite', on: :member
    resources :spaces do
      resources :pages, only: [:index, :new, :create]
    end
  end

  resources :pages, only: [:show, :edit, :update, :destroy]

  devise_for :users,
             skip: [:registration, :sessions],
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get :login, to: "devise/sessions#new", as: :new_user_session
    post :login, to: "devise/sessions#create", as: :user_session
    delete :logout, to: "devise/sessions#destroy", as: :destroy_user_session
  end

  get :landing, to: "landing#index", as: :landing
  get :register, to: "register#index", as: :register

 # resources :invitations

  root "landing#index"
end
