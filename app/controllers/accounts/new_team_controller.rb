class Accounts::NewTeamController < Accounts::BaseController
  before_action :set_user_for_team, :authorize_user_for_new_team, only: [:create, :new]

  # GET /choose_account_for_new_team(.:format)
  def index
  end

  # GET /team_for_account/new/:user_id(.:format)
  def new
    @team_form = Team::CreateTeamForUserForm.new(user: @user_for_team)
  end

  # POST /team_for_account(.:format)
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
      unless user_for_team_available? && UserPolicy.new(pundit_user, @user_for_team).create_team?
        raise Pundit::NotAuthorizedError
      end
    end

    def user_for_team_available?
      available_users.users.include?(@user_for_team)
    end

    def set_user_for_team
      @user_for_team = User.find(params[:user_id])
    end

    def team_params
      params.require(:team).permit(:name, :subdomain).to_h
    end
end
