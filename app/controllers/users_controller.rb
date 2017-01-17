class UsersController < SubdomainBaseController
  before_action :set_user
  layout 'client'

  # GET /users/1
  # GET /users/1.json
  def show
    authorize @user, :show?
  end

  # GET /users/1/edit
  def edit
    authorize @user, :edit?
    @update_settings_form = User::UpdateSettingsForm.new(@user)
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user, :update?
    @update_settings_form = User::UpdateSettingsForm.new(@user, user_params)

    respond_to do |format|
      if @update_settings_form.save
        bypass_sign_in(@update_settings_form.user)
        format.html { redirect_to user_path }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user.decorate
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      case
        when @user.login_using_email? then email_user_params
        when @user.login_using_slack? then slack_user_params
      end
    end

    def slack_user_params
      params.require(:user_update_settings_form).permit(:first_name, :last_name, :avatar)
    end

    def email_user_params
      params.require(:user_update_settings_form).permit(:first_name, :last_name, :avatar, :email, :password, :password_confirmation)
    end
end
