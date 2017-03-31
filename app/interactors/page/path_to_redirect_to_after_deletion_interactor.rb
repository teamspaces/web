class Page::PathToRedirectToAfterDeletionInteractor
  include Interactor

  attr_reader :page_to_delete, :page_to_redirect_to, :controller

  def call
    @page_to_delete = context.page_to_delete
    @page_to_redirect_to = context.page_to_redirect_to
    @controller = context.controller

    context.path = path_to_redirect_to
  end

  def path_to_redirect_to
    case
    when page_to_redirect_to.present? && page_to_redirect_to != page_to_delete
      then controller.edit_page_path(page_to_redirect_to)
    when next_page.present?
      then controller.edit_page_path(next_page)
    else
      controller.space_pages_path(page_to_delete.space)
    end
  end

  private

    def next_page
      Page::NextPageQuery.new(page: page_to_delete).next_page
    end
end


