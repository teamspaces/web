class User::AvatarsController < SubdomainBaseController
  before_action :set_user

  # DELETE /user/avatar
  def destroy
    User::Avatar::AttachGeneratedAvatar.call(user: @user)
    @user.save

    redirect_to user_path
  end

  private

    def set_user
      @user = current_user
    end
end
