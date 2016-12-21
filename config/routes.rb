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
    get '', to: 'teams#show', as: :team
    patch '', to: 'teams#update'
    delete '', to: 'teams#destroy'
  end

  resources :teams, only: [:index, :new, :create]

  devise_for :users,
             skip: [:sessions],
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get :login, to: "devise/sessions#new", as: :new_user_session #TODO
    post :login, to: "devise/sessions#create", as: :user_session #TODO
    delete :logout, to: "devise/sessions#destroy", as: :destroy_user_session
    get :sign_up, to: 'devise/registrations#new', as: :sign_up #TODO
  end

  get :choose_login_method, to: "login_register_funnel/choose_login_method#index", as: :choose_login_method

  get :provide_email_addresss, to: "login_register_funnel/review_email_address#new", as: :new_review_email_address
  post :review_email_address, to: "login_register_funnel/review_email_address#review", as: :review_email_address

  get :email_login, to: "login_register_funnel/email_login#new", as: :new_email_login
  post :email_login, to: "login_register_funnel/email_login#create", as: :email_login

  get :email_register, to: "login_register_funnel/email_register#new", as: :new_email_register
  post :email_register, to: "login_register_funnel/email_register#create", as: :email_register

  get :slack_login, to: "login_register_funnel/slack_login_register#login", as: :slack_login
  get :slack_register, to: "login_register_funnel/slack_login_register#register", as: :slack_register

  get :landing, to: "landing#index", as: :landing

  root "landing#index"
end
