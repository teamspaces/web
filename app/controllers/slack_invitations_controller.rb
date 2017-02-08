class SlackInvitationsController < SubdomainBaseController

  # GET /slack_invitation
  def create
    result = Invitation::CreateAndSendSlackInvitation.call(invitation_params.to_h
                                                      .merge({invited_by_user: current_user,
                                                              team: current_team}))

   # Invitation::SendInvitation.call(invitation: result.invitation) if result.success?

    notice = result.success? ? t("invitation.slack.successfully_sent") :
                               t("invitation.slack.failure_create")

    respond_to do |format|
      format.html { redirect_to invitations_path, notice: notice }
      format.json { head :no_content }
    end
  end

  private

    def invitation_params
      params.permit(:invited_slack_user_uid, :email, :first_name, :last_name)
    end
end
