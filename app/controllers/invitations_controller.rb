class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:destroy]
  before_action :set_team, only: [:index, :create]

  # GET /invitations
  # GET /invitations.json
  def index
    @invitation = current_team_member.invitations.build
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = current_team_member.invitations.new(invitation_params)

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to team_invitations_url(@team), notice: 'Invitation was successfully created.' }
        format.json { render :show, status: :created, location: @invitation }
      else
        format.html { render :index }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:email, :first_name, :last_name)
    end
end
