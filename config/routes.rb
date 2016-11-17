Rails.application.routes.draw do

  constraints subdomain: /^[A-Za-z0-9-]+$/ do
    resources :spaces do
      resources :pages, only: [:index, :new, :create]
    end

    resources :invitations, only: [:index, :create, :destroy]

    get '', to: 'teams#show', as: :team
  end

  resources :pages, only: [:show, :edit, :update, :destroy]

  devise_for :users,
             skip: [:sessions],
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get :login, to: "devise/sessions#new", as: :new_user_session
    post :login, to: "devise/sessions#create", as: :user_session
    delete :logout, to: "devise/sessions#destroy", as: :destroy_user_session
    get :sign_up, to: 'devise/registrations#new', as: :sign_up
  end

  get :landing, to: "landing#index", as: :landing

  root "landing#index"
end
