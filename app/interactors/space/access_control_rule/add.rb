class Space::AccessControlRule::Add
  include Interactor

  def call
    @space = context.space
    @access_control_rule = context.access_control_rule
    @initiating_user = context.initiating_user

    context.fail! unless add_access_control && add_space_member
  end

  private

    def add_access_control
      @space.update(access_control: @access_control_rule)
    end

    def add_space_member
      Space::Members::Add.call(user: @initiating_user, space: @space)
    end
end
