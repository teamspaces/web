class InvitationsController < ApplicationController
  def new
  end

  def create
    @invitation = Invitation.new(invitation_params)

    respond_to do |format|
      if @invitation.save
        format.html { redirect_back(fallback_location: teams_path, notice: 'Invitation was send.') }
        format.json { render :show, status: :created, location: @invitation }
      else
        session[:invitation] = @invitation
        format.html { redirect_back(fallback_location: teams_path) }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def invitation_params
      params.require(:invitation).permit(:team_member_id, :email, :firstname, :lastname)
    end
end
