Rails.application.routes.draw do
  resources :teams
  resources :projects

  get :landing, to: "landing#index", as: :landing
  get :register, to: "register#index", as: :register

  devise_for :users,
             skip: [:registration, :sessions],
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get :login, to: "devise/sessions#new", as: :new_user_session
    post :login, to: "devise/sessions#create", as: :user_session
    delete :logout, to: "devise/sessions#destroy", as: :destroy_user_session
  end

  root "landing#index"
end
