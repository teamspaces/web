class SlackInvitationsController < SubdomainBaseController

  # POST /slack_invitation/:slack_user_id
  def create
    result = Invitation::CreateSlackInvitation.call(user: current_user,
                                                    team: current_team,
                                                    slack_user_id: params[:slack_user_id])

    TeamInvitation::Send.call(invitation: result.invitation) if result.success?

    notice = result.success? ? t('invitation.slack.successfully_sent') :
                               t('invitation.slack.failure_sent')

    respond_to do |format|
      format.html { redirect_to invitations_path, notice: notice }
      format.json { head :no_content }
    end
  end

end
