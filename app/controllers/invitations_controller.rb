class InvitationsController < SubdomainBaseController
  before_action :set_invitation, only: [:destroy]

  # GET /invitations
  # GET /invitations.json
  def index
    @team = current_team
    @invitation_form = SendInvitationForm.new
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

  def create_slack
    Slack::InviteTeamMember.call(user: current_user, team: current_team, slack_id: params[:slack_id])
    redirect_to invitations_path, notice: 'Invitation was successfully created.'
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
