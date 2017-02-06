class Space::InvitationsController < SubdomainBaseController
  before_action :set_space
  before_action :set_space_member, only: :destroy

  layout 'client'

  # DELETE /spaces/:space_id/members/:id
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

    def set_space_member
      @space_member = SpaceMember.find_by(space: @space, team_member_id: params[:id])
    end

    def space_member_params
      params.require(:space_member).permit(:team_member_id).to_h
    end
end
