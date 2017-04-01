class Team::NewTeamsController < AccountsBaseController
  before_action :set_user_for_team, :authorize_user_for_new_team, only: [:create, :new]

  def index
    @users_for_team = available_users.users
  end

  def new
    @team_form = Team::CreateTeamForUserForm.new(user: @user_for_team)
  end

  def create
    @team_form = Team::CreateTeamForUserForm.new(user: @user_for_team, attributes: team_params)

    if @team_form.save
      redirect_to sign_in_url_for(user: @user_for_team, created_team_to_redirect_to: @team_form.team)
    else
      render :new
    end
  end

  private

    def authorize_user_for_new_team
      unless AvailableUsersPolicy.new(available_users, @user_for_team).create_team?
        raise Pundit::NotAuthorizedError
      end
    end

    def set_user_for_team
      @user_for_team = User.find(params[:user_id])
    end

    def team_params
      params.require(:team).permit(:name, :subdomain).to_h
    end
end
