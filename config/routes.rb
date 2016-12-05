Rails.application.routes.draw do

  constraints !ReservedSubdomain do
    resources :spaces do
      resources :pages, only: [:index, :new, :create]
    end

    resources :invitations, only: [:index, :create, :destroy]

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

  get :method, to: "funnel#method", as: :method
  get :slack_method, to: "funnel#slack_method", as: :slack_method
  get :email_method, to: "funnel#email_method", as: :email_method
  get :email_login, to: "funnel#email_login", as: :email_login
  get :email_register, to: "funnel#email_register", as: :email_register

  root "landing#index"
end
