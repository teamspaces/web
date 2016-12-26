Rails.application.routes.draw do

  constraints !ReservedSubdomain do
    resources :spaces do
      resources :pages, only: [:index, :new, :create]
    end

    resources :pages, only: [:show, :edit, :update, :destroy]
    resources :page_contents, only: [:show, :update]

    resources :invitations, only: [:index, :create, :destroy]
    get 'slack_invitation', to: 'slack_invitations#create', as: :create_slack_invitation

    get :edit, to: 'teams#edit', as: :edit_team
    patch '', to: 'teams#update'
    delete '', to: 'teams#destroy'

    resources :teams, only: [:show, :update, :destroy]

    # get '', to: 'teams#show', as: :team
    get '', to: "root_subdomain#index", as: :root_subdomain
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
