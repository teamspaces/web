class InvitationsController < SubdomainBaseController
  before_action :set_invitation, only: [:destroy]
  before_action :set_team, :find_invitable_slack_users, only: [:index, :create]
  layout 'client'

  # GET /invitations
  # GET /invitations.json
  def index
    @invitation_form = SendInvitationForm.new
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation_form = SendInvitationForm.new(team: @team,
                                              invited_by_user: current_user,
                                              params: invitation_params)

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

    def set_team
      @team = current_team.decorate
    end

    def find_invitable_slack_users
      @slack_users_to_invite = Team::FindInvitableSlackUsers.new(@team).all if @team.connected_to_slack?
    end

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def invitation_params
      params.require(:send_invitation_form).permit(:email, :first_name, :last_name).to_h
    end
end
