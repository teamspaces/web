class PageSettingsHashPresenter

  attr_reader :controller, :page

  def initialize(controller:, page:)
    @controller = controller
    @page = page
  end

  def to_hash
    { page_url: controller.page_url(page),
      csrf_token: controller.view_context.form_authenticity_token }
  end
end

