class UserTeamsFunnel::CreateTeamController < UserTeamsFunnelController

  def new
    @team_form = CreateTeamForUserForm.new
  end

  def create
    user = user_teams_funnel_current_user

    @team_form = CreateTeamForUserForm.new(create_team_for_user_form_params.to_h
                                           .merge(user: user))

    respond_to do |format|
      if @team_form.save
        remove_user_teams_funnel_current_user

        format.html { redirect_to team_url(subdomain: @team_form.team.subdomain, auth_token: GenerateLoginToken.call(user: user)) }
        format.json { render :show, status: :created, location: @team_form.team }
      else
        format.html { render :new }
        format.json { render json: @team_form.errors, status: :unprocessable_entity }
      end
    end
  end


  def create_team_for_user_form_params
    params.require(:create_team_for_user_form)
          .permit(:name, :subdomain)
  end
end
