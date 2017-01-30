class User::PasswordsController < Devise::PasswordsController

  # overwrite unnecessary devise action
  def new
    redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    new_login_register_funnel_after_reset_password_path
  end

  def after_resetting_password_path_for(resource)
    sign_in(resource)
  end

end
