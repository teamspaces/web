class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:destroy]
  before_action :set_team, only: [:index, :create]
  before_action :authorize_association

  # GET /invitations
  # GET /invitations.json
  def index
    @invitation_form = SendInvitationForm.new
  end

  # POST /invitations
  # POST /invitations.json
  def create
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

    def set_team
      @team = current_team
    end

    def send_invitation_form_params
      params.require(:send_invitation_form).permit(:email, :first_name, :last_name)
    end

    def authorize_association
      if @invitation
        authorize(@invitation, :associated?)
      else
        authorize(current_team, :associated?)
      end
    end

    def pundit_user
      TeamPolicy::Context.new(current_user, current_team)
    end
end
