[ Devise::SessionsController,
  Devise::RegistrationsController ].each do |devise_controller_class|
    devise_controller_class.before_action :set_invitation_cookie_from_params, only: :new
end
