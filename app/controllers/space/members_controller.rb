class Space::MembersController < SubdomainBaseController
  before_action :set_space
  before_action :set_space_member, only: :destroy

  layout 'client'

  # GET /spaces/:space_id/members
  def index
    @space_users = @space.users.decorate
    @team_users = @space.team.users.decorate
  end

  # POST /spaces/:space_id/members
  def create
    @space_member = SpaceMember.new(space: @space, team_member_id: space_member_params[:team_member_id])

    authorize @space_member, :create?

    respond_to do |format|
      if @space_member.save
        format.html { redirect_to space_members_path(@space) }
        format.json { render :show, status: :created, location: @space_member }
      else
        format.html { render :new }
        format.json { render json: @space_member.errors, status: :unprocessable_entity }
      end
    end
  end

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
      @space_member = SpaceMember.find(params[:id])
    end

    def space_member_params
      params.require(:space_member).permit(:team_member_id).to_h
    end
end
