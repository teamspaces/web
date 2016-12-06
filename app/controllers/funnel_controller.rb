class FunnelController < ApplicationController
  skip_before_action :authenticate_user!

  def method
  end

  def slack_method
  end

  def email_method
    @email_form = Funnel::EmailForm.new

    if request.post?
      @email_form = Funnel::EmailForm.new(email_form_params)

      if @email_form.valid?
        existing_user = User.find_by(email: @email_form.email)

        if existing_user
          if existing_user.allow_email_login
            redirect_to email_login_path(email: @email_form.email)
          else
            redirect_to slack_method_path
          end
        else
          redirect_to email_register_path(email: @email_form.email)
        end
      else
        render :email_method
      end
    end
  end

  def email_login
  end

  def email_register
  end

  private

    def email_form_params
      params.require(:funnel_email_form).permit(:email)
    end
end


