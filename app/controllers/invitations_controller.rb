class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:destroy]
  before_action :set_team, only: [:index, :create]

  # GET /invitations
  # GET /invitations.json
  def index
    @invitation_form = Invitation::InvitationForm.new
  end

  # POST /invitations
  # POST /invitations.json
  def create
    result = Invitation::CreateAndSendJoinTeamMail.call(team: @team, user: current_user,
                                                        invitation_params: invitation_form_params)
    @invitation_form = result.invitation_form

    respond_to do |format|
      if result.success?
        format.html { redirect_to team_invitations_url(@team), notice: 'Invitation was successfully created.' }
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
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to team_invitations_url(@invitation.team), notice: 'Invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def set_team
      @team = Team.find(params[:team_id])
    end

    def invitation_form_params
      params.require(:invitation_invitation_form).permit(:email, :first_name, :last_name)
    end
end
