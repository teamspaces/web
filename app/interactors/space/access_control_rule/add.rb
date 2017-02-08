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
      Space::AccessControlRule::Enforce.call(user: @initiating_user, space: @space)
    end
end
