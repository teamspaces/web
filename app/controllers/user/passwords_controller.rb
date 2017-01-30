class User::PasswordsController < Devise::PasswordsController

  def after_sending_reset_password_instructions_path_for(resource_name)
    new_login_register_funnel_after_reset_password_path
  end

  def after_resetting_password_path_for(resource)
    new_login_register_funnel_after_reset_password_path
  end

end
