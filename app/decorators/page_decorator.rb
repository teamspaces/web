class PageDecorator < Draper::Decorator
  delegate_all

  def title_with_fallback
    object.title || "Untitled"
  end
end
