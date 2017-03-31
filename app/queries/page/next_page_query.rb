class Page::NextPageQuery

  attr_reader :page, :space

  def initialize(page:)
    @page = page
    @space = page.space
  end

  def next_page
    case
      when parent.present? then parent
      when sibling_before.present? then sibling_before
      when sibling_after.present? then sibling_after
    end
  end

  private

    def parent
      page.parent
    end

    def sibling_before
      page.siblings_before
          .where(space: @space)
          .last
    end

    def sibling_after
      page.siblings_after
          .where(space: @space)
          .first
    end
end
