class InvitationsController < SubdomainBaseController
  before_action :set_invitation, only: [:destroy]

  # GET /invitations
  # GET /invitations.json
  def index
    @team = current_team
    @invitation_form = SendInvitationForm.new

    result = Slack::FetchTeamProfiles.call(team: @team)

    @slack_profiles_to_invite = SlackProfileQuery.new.to_invite_for(@team)
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @team = current_team
    @invitation_form = SendInvitationForm.new(send_invitation_form_params.to_h
                                              .merge(team: @team, user: current_user))

    respond_to do |format|
      if @invitation_form.save
        format.html { redirect_to invitations_path, notice: 'Invitation was successfully created.' }
        format.json { render :show, status: :created, location: @invitation_form.invitation }
      else
        format.html { render :index }
        format.json { render json: @invitation_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /slack_invitation/:uid
  def create_slack_invitation
    slack_profile = SlackProfile.find_by(user_id: params[:uid])

    result = Invitation::CreateSlackInvitation.call(user: current_user,
                                                    team: current_team,
                                                    slack_profile: slack_profile)

    invitation_url = sign_up_url(subdomain: current_team.subdomain,
                                 invitation_token: result.slack_invitation.token)

    result = Slack::SendInvitation.call(invitation: result.slack_invitation,
                                        invitation_url: invitation_url)

    notice = result.success? ? t('invitation.slack.successfully_sent') :
                               t('invitation.slack.failure_sent')

    respond_to do |format|
      format.html { redirect_to invitations_path, notice: notice }
      format.json { head :no_content }
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    authorize @invitation, :destroy?

    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_path, notice: 'Invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def send_invitation_form_params
      params.require(:send_invitation_form).permit(:email, :first_name, :last_name)
    end
end
