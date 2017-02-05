class Space::Invitations::EmailController < SubdomainBaseController
  before_action :set_space
  before_action :set_invitation, only: [:destroy]

  layout 'client'

  #GET /spaces/:space_id/invitations/new
  def new
    @invitation_form = SendInvitationForm.new
  end

  # POST /spaces/:space_id/invitations
  def create
    @invitation_form = SendInvitationForm.new(team: current_team,
                                              space: @space,
                                              invited_by_user: current_user,
                                              attributes: invitation_params)

    respond_to do |format|
      if @invitation_form.save
        format.html { redirect_to space_members_path(@space), notice: 'Invitation was successfully created.' }
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

    def set_space
      @space = Space.find_by(id: params[:space_id])
    end

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def invitation_params
      params.require(:invitation).permit(:email, :first_name, :last_name).to_h
    end
end
