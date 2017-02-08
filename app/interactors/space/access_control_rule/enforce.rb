class Space::AccessControlRule::Enforce
  include Interactor

  def call
    @space = context.space
    @user = context.user

    context.fail! unless enforce_access_control_rule
  end

  private

    def enforce_access_control_rule
      case @space.access_control_rule
        when Space::AccessControlRules::PRIVATE
          Space::Members::Add.call(user: @initiating_user)
        when Space::AccessControlRules::TEAM
          Space::Members::RemoveAll.call(space: @space)
      end
    end
end




