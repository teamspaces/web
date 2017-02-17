class SpaceSettingsHashPresenter

  attr_reader :controller, :space

  def initialize(controller:, space:)
    @controller = controller
    @space = space
  end

  def to_hash
    { space_url: controller.space_url(space),
      csrf_token: controller.view_context.form_authenticity_token }
  end
end
