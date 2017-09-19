module DeletePageConfirmationMessageHelper
  def delete_page_confirmation_message(page)
    descendants_count = page.descendants.count

    if descendants_count.positive?
      "Do you really want to delete this page and #{descendants_count} #{'subpage'.pluralize(descendants_count)}?"
    else
      "Are you sure?"
    end
  end
end
