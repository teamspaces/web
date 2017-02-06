class Space::AccessControl::Remove
  include Interactor

  def call
    @space = context.space

    context.fail! unless remove_access_control && remove_space_members
  end

  private

    def remove_access_control
      @space.update(access_control: false)
    end

    def remove_space_members
      @space.space_members.destroy_all
    end
end
