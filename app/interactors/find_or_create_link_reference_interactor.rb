class FindOrCreateLinkReferenceInteractor
  attr_reader :link, :page

  def call
    @link = context.link
    @page = context.page

    find_or_create_reference
  end

  def find_or_create_reference
    if route.present?
      LinkReference.find_or_create_by(page_id: @page.id,
                                      reference_id: route[:id],
                                      reference_model: path[:controller].singularize)
    end
  end

  def route
    begin
      ActionController::Routing::Routes.recognize_path URI(@link).path
    rescue
    end
  end
end
