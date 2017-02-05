class Space::Invitations::SlackController < SubdomainBaseController
  before_action :set_space

  def new
    @team = @space.team.decorate
    @slack_users_to_invite = Team::FindInvitableSlackUsers.new(@team).all if @team.connected_to_slack?
  end

  # GET /slack_invitation
  def create
    result = Invitation::CreateSlackInvitation.call(invitation_params.to_h
                                                    .merge({invited_by_user: current_user,
                                                            team: current_team}))

    Invitation::SendInvitation.call(invitation: result.invitation) if result.success?

    notice = result.success? ? t("invitation.slack.successfully_sent") :
                               t("invitation.slack.failure_create")

    respond_to do |format|
      format.html { redirect_to space_members_path(@space), notice: notice }
      format.json { head :no_content }
    end
  end

  private

    def invitation_params
      params.permit(:invited_slack_user_uid, :email, :first_name, :last_name)
    end

    def set_space
      @space = Space.find_by(id: params[:space_id])
    end

end
