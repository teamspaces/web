class Space::AccessControl::Add
  include Interactor

  def call
    @space = context.space
    @initiating_user = context.initiating_user

    context.fail! unless add_access_control && add_space_member
  end

  private

    def add_access_control
      @space.update(access_control: true)
    end

    def add_space_member
      Space::Members::Add.call(user: @initiating_user, space: @space)
    end
end
