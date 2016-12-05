class LandingController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def sign_in_method
  end

  def sign_in_with_email
    email = params.permit(:email)[:email]

    if email
      user = User.find_by(email: email)

      if user
        if user.allow_email_login

        else

        end
      else

      end
    end
  end
end
