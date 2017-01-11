class UsersController < SubdomainBaseController
  before_action :set_user
  layout 'client'

  # GET /users/1
  # GET /users/1.json
  def show
      img = Avatarly.generate_avatar(@user.name)
  t = Tempfile.new("test_temp.png",  :encoding => 'ascii-8bit')
  t.write(img)

  t.close
  @user.avatar = File.new(t)
  @user.save

  t.delete



    authorize @user, :show?
  end

  # GET /users/1/edit
  def edit
    authorize @user, :edit?
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user, :update?

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize @user, :destroy?

    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]) }
      format.json { head :no_content }
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
      params.require(:user).permit(:first_name, :last_name, :avatar)
    end

    def email_user_params
      params.require(:user).permit(:first_name, :last_name, :avatar, :email, :password, :password_confirmation)
    end
end
