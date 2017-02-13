class Team::MembersController < SubdomainBaseController
  before_action :set_team, :set_team_member

  # DELETE /team/members/:id
  def destroy
    authorize @team_member, :destroy?

    Authie::Session.sign_out_team_member_from_team_subdomain(@team_member)
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
