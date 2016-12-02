Rails.application.routes.draw do

  constraints !ReservedSubdomain do
    resources :spaces do
      resources :pages, only: [:index, :new, :create]
    end

    resources :pages, only: [:show, :edit, :update, :destroy]
    resources :page_contents, only: [:show, :update]

    resources :invitations, only: [:index, :create, :destroy]
    get 'accept/:token', to: 'invitations/accept#show', as: :accept_invitation

    get 'login/:token', to: 'invitations/login#new', as: :login_with_invitation
    post 'login/:token', to: 'invitations/login#create', as: :login_with_invitation_forms

    get 'register/:token', to: 'invitations/register#new', as: :register_with_invitation
    post 'register/:token', to: 'invitations/register#create', as: :register_with_invitation_forms

    get :edit, to: 'teams#edit', as: :edit_team
    get '', to: 'teams#show', as: :team
    patch '', to: 'teams#update'
    delete '', to: 'teams#destroy'
  end

  resources :teams, only: [:index, :new, :create]

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
