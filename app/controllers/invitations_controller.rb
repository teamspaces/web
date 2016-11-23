class InvitationsController < SubdomainBaseController
  skip_before_action :authenticate_user!, only: [:join]
  skip_before_action :check_team_membership, only: [:join]
  before_action :set_invitation, only: [:destroy]

  # GET /join
  def join
    @invitation = Invitation.find_by(token: params[:token])
  end

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
