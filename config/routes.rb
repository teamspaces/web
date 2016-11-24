Rails.application.routes.draw do

  constraints subdomain: /^[A-Za-z0-9-]+$/ do
    resources :spaces do
      resources :pages, only: [:index, :new, :create]
    end

    resources :invitations, only: [:index, :create, :destroy]
    get 'join/:token', to: 'accept_invitations#show', as: :accept_invitation
    get 'join_login/:token', to: 'accept_invitations#new_login',as: :accept_invitation_login
    post 'join_login/:token', to: 'accept_invitations#create_login', as: :login_with_invitation_forms
    get 'join_register/:token', to: 'accept_invitations#new_register',as: :accept_invitation_register
    post 'join_register/:token', to: 'accept_invitations#create_register', as: :register_with_invitation_forms

    get :edit, to: 'teams#edit', as: :edit_team
    get '', to: 'teams#show', as: :team
    patch '', to: 'teams#update'
    delete '', to: 'teams#destroy'
  end

  resources :teams, only: [:index, :new, :create]
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
