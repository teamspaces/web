class Space::AccessControlRule::Update
  include Interactor

  def call
    @space = context.space
    @access_control_rule = context.access_control_rule

    context.fail! unless update_access_control_rule
  end

  private

    def update_access_control_rule
      @space.update(access_control_rule: @access_control_rule)
    end
end
