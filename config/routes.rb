Rails.application.routes.draw do
  constraints ReservedSubdomain do
    get :login_into_team, to: "login_register_funnel/login_into_team#new", as: :login_into_team

    resources :spaces do
      resources :pages, only: [:index, :new, :create]
    end

    resource :team, only: [:show, :edit, :update, :destroy]

    resource :user, except: [:index, :destroy]

    resources :pages, only: [:show, :edit, :update, :destroy]
    resources :page_contents, only: [:show, :update]

    resources :invitations, only: [:index, :create, :destroy]
    get "slack_invitation", to: "slack_invitations#create", as: :create_slack_invitation

    get "/", to: "root_subdomain#index", as: :root_subdomain
  end

  devise_for :users,
             skip: [:sessions],
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    delete :logout, to: "devise/sessions#destroy", as: :destroy_user_session
  end

  constraints subdomain: ENV["DEFAULT_SUBDOMAIN"] do
    get :choose_login_method, to: "login_register_funnel/choose_login_method#index", as: :choose_login_method

    get :provide_email_addresss, to: "login_register_funnel/review_email_address#new", as: :new_review_email_address
    post :review_email_address, to: "login_register_funnel/review_email_address#review", as: :review_email_address

    get :email_register, to: "login_register_funnel/email_register#new", as: :new_email_register
    post :email_register, to: "login_register_funnel/email_register#create", as: :email_register

    get :slack_login, to: "login_register_funnel/slack_login_register#login", as: :slack_login
    get :slack_register, to: "login_register_funnel/slack_login_register#register", as: :slack_register

    get "accept_invitation/:invitation_token", to: "login_register_funnel/accept_invitation#new", as: :accept_invitation

    get :create_team, to: "login_register_funnel/teams#new", as: :login_register_funnel_new_team
    post :create_team, to: "login_register_funnel/teams#create", as: :login_register_funnel_create_team

    get "team/:team_subomain", to: "login_register_funnel/teams#show", as: :show_team_subdomain
    get :choose_team, to: "login_register_funnel/teams#index", as: :login_register_funnel_list_teams
  end

  get :email_login, to: "login_register_funnel/email_login#new", as: :new_email_login
  post :email_login, to: "login_register_funnel/email_login#create", as: :email_login


  get :temporary_landing, to: "landing#index", path: "/landing"

  root "landing#blank"
end
