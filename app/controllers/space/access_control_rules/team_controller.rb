class Space::AccessControlRules::TeamController < SubdomainBaseController
  before_action :set_space

  # POST /spaces/:space_id/access_control_rules/team
  def create
    authorize @space, :update?

    Space::AccessControlRule::Add.call(space: @space,
                                       access_control_rule: Space::AccessControlRules::TEAM,
                                       initiating_user: current_user)

    redirect_to space_members_path(@space)
  end

  private

    def set_space
      @space = Space.find(params[:space_id])
    end
end
