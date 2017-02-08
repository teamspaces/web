class Space::AccessControlRule::Add
  include Interactor

  def call
    @space = context.space
    @access_control_rule = context.access_control_rule
    @initiating_user = context.initiating_user

    context.fail! unless update_access_control_rule && enforce_access_control_rule
  end

  private

    def update_access_control_rule
      @space.update(access_control_rule: @access_control_rules)
    end

    def enforce_access_control_rule
      case @access_control_rule
        when Space::AccessControlRules::PRIVATE
          Space::Members::Add.call(user: @initiating_user)
        when Space::AccessControlRules::TEAM
          Space::Members::RemoveAll.call(space: @space)
      end
    end
end
