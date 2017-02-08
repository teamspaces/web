class Space::Members::Remove
  include Interactor

  def call
    @space = context.space

    context.fail! unless remove_all_space_member
  end

  private

    def remove_all_space_member
      @space.space_members.destroy_all
    end
end
