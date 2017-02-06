class Space::InvitationsController < SubdomainBaseController
  before_action :set_space, :set_invitation

  layout 'client'

  # DELETE /spaces/:space_id/invitations/:id
  def destroy
    authorize @space_member, :destroy?

    @space_member.destroy
    respond_to do |format|
      format.html { redirect_to space_members_path(@space) }
      format.json { head :no_content }
    end
  end

  private

    def set_space
      @space = Space.find(params[:space_id])
    end

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end
end
