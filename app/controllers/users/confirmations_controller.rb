class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    @user = User.confirm_by_token(params[:confirmation_token])

    if @user.errors.empty?
      redirect_to sign_in_url_for(user: @user)
    else
      #respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

end
