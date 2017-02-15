class Team::MembersController < SubdomainBaseController
  before_action :set_team, :set_team_member

  # DELETE /team/members/:id
  def destroy
    authorize @team_member, :destroy?

    DestroyUserSessionQuery.new(@team_member.user)
                           .for_team!(@team_member.team)
    @team_member.destroy

    redirect_to team_path
  end

  private

    def set_team_member
      @team_member = @team.members.find(params[:id])
    end

    def set_team
      @team = current_team
    end
end
