class Space::Members::RemoveAll
  include Interactor

  def call
    @space = context.space

    context.fail! unless remove_all_space_members
  end

  private

    def remove_all_space_members
      @space.space_members.find_each(&:really_destroy!)
    end
end
