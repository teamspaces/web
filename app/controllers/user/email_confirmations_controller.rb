class User::EmailConfirmationsController < Devise::ConfirmationsController

  def new
    super
  end


  def create
    super
  end

  def show
    super
  end

  private
  def after_confirmation_path_for(resource_name, resource)
    choose_login_method_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
  end

  def after_resending_confirmation_instructions_path_for(resource_name)
    choose_login_method_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
  end
end
