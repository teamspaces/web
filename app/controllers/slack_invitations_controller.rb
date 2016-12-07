class SlackInvitationsController < SubdomainBaseController
  before_action :set_invitation, only: [:destroy]


  # POST /slack_invitation/:uid
  def create
    result = Invitation::CreateSlackInvitation.call(user: current_user,
                                                    team: current_team,
                                                    slack_user_id: params[:uid])

    #invitation_url = sign_up_url(subdomain: current_team.subdomain,
    #                             invitation_token: result.slack_invitation.token)

    #result = Slack::SendInvitation.call(invitation: result.slack_invitation,
    #                                    invitation_url: invitation_url)

    notice = result.success? ? t('invitation.slack.successfully_sent') :
                               t('invitation.slack.failure_sent')

    respond_to do |format|
      format.html { redirect_to invitations_path, notice: notice }
      format.json { head :no_content }
    end
  end

end
