class Space::AccessControl::Update
  include Interactor

  def call
    @space = context.space
    @access_control = context.access_control

    context.fail! unless update_access_control
  end

  private

    def update_access_control
      @space.update(access_control: @access_control)
    end
end
