Rails.application.routes.draw do
  resources :teams
  resources :projects

  devise_for :users,
             skip: [:registration],
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'landing#index'
end
