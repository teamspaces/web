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
    get :login, to: "devise/sessions#new", as: :new_user_session
    post :login, to: "devise/sessions#create", as: :user_session
    delete :logout, to: "devise/sessions#destroy", as: :destroy_user_session
    get :sign_up, to: 'devise/registrations#new', as: :sign_up
  end

  get :choose_login_method, to: "login_register_funnel/choose_login_method#index",
                            as: :choose_login_method

  get :review_email_address, to: "login_register_funnel/review_email_address#new",
                             as: :reveal_email_address

  post :review_email_address, to: "login_register_funnel/review_email_address#review",
                              as: :review_email_address

  get :choose_sign_in_method, to: "login_sign_up_funnel#choose_sign_in_method",
                              as: :choose_sign_in_method
  get :email_sign_in_method, to: "login_sign_up_funnel#email_sign_in_method",
                             as: :email_sign_in_method
  post :check_email_address, to: "login_sign_up_funnel#check_email_address",
                             as: :check_email_address
  get :email_register, to: "login_sign_up_funnel#email_register",
                       as: :email_register
  get :slack_sign_in_method, to: "login_sign_up_funnel#slack_sign_in_method",
                             as: :slack_sign_in_method

  get :landing, to: "landing#index", as: :landing

  root "landing#index"
end
