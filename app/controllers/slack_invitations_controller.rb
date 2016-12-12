class SlackInvitationsController < SubdomainBaseController

  # GET /slack_invitation
  def create
    result = Invitation::CreateSlackInvitation.call(invitation_params.to_h
                                                    .merge({user: current_user,
                                                            team: current_team}))

    SendInvitation.call(invitation: result.invitation) if result.success?

    notice = result.success? ? t("invitation.slack.successfully_sent") :
                               t("invitation.slack.failure_sent")

    respond_to do |format|
      format.html { redirect_to invitations_path, notice: notice }
      format.json { head :no_content }
    end
  end

  private

    def invitation_params
      params.permit(:slack_user_id, :email, :first_name, :last_name)
    end
end
