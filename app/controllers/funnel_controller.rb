class FunnelController < ApplicationController
  skip_before_action :authenticate_user!

  def method
  end

  def slack_method
  end

  def email_method
    email = params.permit(:email)[:email]

    if email
      existing_user = User.find_by(email: email)

      if existing_user
        if existing_user.allow_email_login
          redirect_to email_login_path(email: email)
        else
          redirect_to slack_method_path
        end
      else
        redirect_to email_register_path(email: email)
      end
    end
  end

  def email_login
  end

  def email_register
  end
end


