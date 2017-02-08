class Space::AccessControlRules::PrivateController < SubdomainBaseController
  before_action :set_space

  # POST /spaces/:space_id/access_control_rules/private
  def create
    authorize @space, :update_access_control?

    Space::AccessControlRule::Add.call(space: @space,
                                       access_control_rule: Space::AccessControlRules::PRIVATE,
                                       initiating_user: current_user)

    redirect_to space_members_path(@space)
  end

  private

    def set_space
      @space = Space.find(params[:space_id])
    end
end
