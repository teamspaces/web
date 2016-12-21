class LoginRegisterFunnel::TeamsController < LoginRegisterFunnelController
  before_action :authenticate_user!

  def new
    @team_form = CreateTeamForUserForm.new
  end

  def create
    @team_form = CreateTeamForUserForm.new(create_team_for_user_form_params.to_h
                                           .merge(user: current_user))

    if @team_form.save
      redirect_to sign_in_path_for(current_user)

      sign_out_user_from_default_subdomain
    else
      render :new
    end
  end

  def show
    team = current_user.teams.find_by(subdomain: params[:team_subomain])

    redirect_to team_url(subdomain: team.subdomain, auth_token: GenerateLoginToken.call(user: current_user))

    sign_out_user_from_default_subdomain
  end

  def index
    @teams = current_user.teams
  end

  private

    def sign_out_user_from_default_subdomain
      sign_out(current_user)
    end

    def create_team_for_user_form_params
      params.require(:create_team_for_user_form).permit(:name, :subdomain)
    end
end
