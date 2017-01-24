class Team::LogosController < SubdomainBaseController
  before_action :set_team

  # DELETE /team/logo
  def destroy
    authorize @team, :update?

    Team::Logo::AttachGeneratedLogo.call(team: @team)
    @team.save

    redirect_to team_path
  end

  private

    def set_team
      @team = current_team
    end
end
