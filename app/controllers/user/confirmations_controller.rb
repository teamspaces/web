class User::ConfirmationsController < Devise::ConfirmationsController

  def show
    @user = User.confirm_by_token(params[:confirmation_token])

    if @user.errors.empty?
      redirect_to sign_in_url_for(user: @user, created_team_to_redirect_to: @user.recently_created_team)
    else
      flash[:notice] = @user.errors.full_messages.to_sentence

      redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
  end
end
