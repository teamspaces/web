class Space::AccessControlsController < SubdomainBaseController
  before_action :set_space

  # POST /spaces/:space_id/access_control
  def create
    authorize @space, :update?

    space.update(access_control: true)

    redirect_to space_path
  end

  # DELETE /spaces/:space_id/access_control
  def destroy
    authorize @space, :update?

    space.update(access_control: false)

    redirect_to space_path
  end

  private

    def set_space
      @space = Space.find(params[:id])
    end
end
