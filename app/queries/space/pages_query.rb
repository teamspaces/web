class Space::PagesQuery

  attr_reader :space

  def initialize(space)
    @space = space
  end

  def root_page
    pages.where(parent_id: nil)
         .order(sort_order: :asc)
         .limit(1)
         .first
  end

  private

    def pages
      space.pages
    end
end
