class SlackInvitationsController < SubdomainBaseController

  # GET /slack_invitation
  def create
    result = Invitation::CreateAndSendSlackInvitation.call(team: current_team,
                                                           invited_by_user: current_user,
                                                           invitation_attributes: invitation_params)

    notice = result.success? ? t("invitation.slack.successfully_sent") :
                               t("invitation.slack.failure_create")

    respond_to do |format|
      format.html { redirect_to invitations_path, notice: notice }
      format.json { head :no_content }
    end
  end

  private

    def invitation_params
      params.permit(:invited_slack_user_uid, :email, :first_name, :last_name).to_h
    end
end
