class User::PasswordsController < Devise::PasswordsController

  def after_sending_reset_password_instructions_path_for(resource_name)
    new_login_register_funnel_after_sent_reset_password_instruction_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
  end
end