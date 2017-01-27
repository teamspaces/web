class LoginRegisterFunnel::TeamsController < LoginRegisterFunnel::BaseController
  skip_before_action :redirect_if_user_already_signed_in
  before_action :authenticate_user!

  def new
    shared_user_info.start_team_creation!

    @team_form = Team::Form.new(team: policy_scope(Team).build)
  end

  def create
    @team_form = Team::Form.new(team: policy_scope(Team).build, params: team_params)

    if @team_form.save && CreateTeamMemberForNewTeam.call(user: user, team: @team_form.team)
      redirect_to sign_in_url_for(user: current_user, created_team_to_redirect_to: @team_form.team)

      sign_out_user_from_default_subdomain(current_user)
    else
      render :new
    end
  end

  def show
    team = current_user.teams.find_by(subdomain: params[:team_subomain])

    redirect_to sign_in_url_for(user: current_user, team_to_redirect_to: team)

    sign_out_user_from_default_subdomain(current_user)
  end

  def index
    @teams = current_user.teams
  end

  private

    def team_params
      params.require(:team).permit(:name, :subdomain, :logo).to_h
    end
end
