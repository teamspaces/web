class Space::AccessControlsController < SubdomainBaseController
  before_action :set_space

  # POST /spaces/:space_id/access_control
  def create
    authorize @space, :update?

    @space.update(access_control: true)

    redirect_to space_members_path(@space)
  end

  # DELETE /spaces/:space_id/access_control
  def destroy
    authorize @space, :update?

    @space.update(access_control: false)

    redirect_to space_members_path(@space)
  end

  private

    def set_space
      @space = Space.find(params[:space_id])
    end
end
