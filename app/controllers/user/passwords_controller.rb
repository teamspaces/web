class User::PasswordsController < Devise::PasswordsController

  def after_resetting_password_path_for(resource)
    sign_in_url_for(user: resource)
  end
end
