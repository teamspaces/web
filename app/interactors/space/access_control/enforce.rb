class Space::AccessControl::Enforce
  include Interactor

  def call
    @space = context.space
    @user = context.user

    context.fail! unless enforce_access_control
  end

  private

    def enforce_access_control
      case
        when @space.access_control.private?
          Space::Members::Add.call(user: @user, space: @space)
        when @space.access_control.team?
          Space::Members::RemoveAll.call(space: @space)
      end
    end
end
