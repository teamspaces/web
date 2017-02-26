class Space::AccessControlController < SubdomainBaseController
  before_action :set_space

  # PATCH /spaces/:space_id/access_control
  def update
    authorize @space, :update_access_control?

    Space::Form.new(space: @space,
                    user: current_user,
                    attributes: space_params).save

    redirect_to space_members_path(@space)
  end

  private

    def set_space
      @space = Space.find(params[:space_id])
    end

    def space_params
      params.require(:space).permit(:access_control).to_h
    end
end
