class Space::MembersController < SubdomainBaseController
  before_action :set_space

  layout 'client'

  # GET /spaces/:space_id/members
  def index
    @space_team_members = @space.team_members
    @team_members = @space.team.members
    @space_invitations = @space.invitations
  end

  # POST /spaces/:space_id/members
  def create
    authorize @space, :add_member?

    Space::Members::Add.call(space: @space, user: User.find(space_member_params[:user_id]))

    respond_to do |format|
      format.html { redirect_to space_members_path(@space) }
      format.json { render :show, status: :created }
    end
  end

  # DELETE /spaces/:space_id/members/:user_id
  def destroy
    authorize @space, :remove_member?

    Space::Members::Remove.call(space: @space, user: User.find(params[:user_id]))

    respond_to do |format|
      format.html { redirect_to space_members_path(@space) }
      format.json { head :no_content }
    end
  end

  private

    def set_space
      @space = Space.find(params[:space_id])
    end

    def space_member_params
      params.require(:space_member).permit(:user_id).to_h
    end
end
