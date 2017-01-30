class LoginRegisterFunnel::TeamsController < LoginRegisterFunnel::BaseController
  skip_before_action :redirect_if_user_already_signed_in
  before_action :authenticate_user!

  def new
    shared_user_info.start_team_creation!

    @team_form = Team::CreateTeamForUserForm.new
  end

  def create
    @team_form = Team::CreateTeamForUserForm.new(create_team_for_user_form_params.to_h
                                                 .merge(user: current_user))

    if @team_form.save
      redirect_to sign_in_url_for(user: current_user, created_team_to_redirect_to: @team_form.team)

      sign_out_from_subdomain
    else
      render :new
    end
  end

  def show
    team = current_user.teams.find_by(subdomain: params[:team_subomain])

    redirect_to sign_in_url_for(user: current_user, team_to_redirect_to: team)

    sign_out_from_subdomain
  end

  def index
    @teams = current_user.teams
  end

  private

    def create_team_for_user_form_params
      params.require(:team_create_team_for_user_form)
            .permit(:name, :subdomain, :logo)
    end
end
