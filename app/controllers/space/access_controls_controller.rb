class Space::AccessControlsController < SubdomainBaseController
  before_action :set_space

  # POST /spaces/:space_id/access_control
  def create
    authorize @space, :update?

    Space::AccessControl::Add.call(space: space, initiating_user: user)

    redirect_to space_members_path(@space)
  end

  # DELETE /spaces/:space_id/access_control
  def destroy
    authorize @space, :update?

    Space::AccessControl::Remove.call(space: space)

    redirect_to space_members_path(@space)
  end

  private

    def set_space
      @space = Space.find(params[:space_id])
    end
end
