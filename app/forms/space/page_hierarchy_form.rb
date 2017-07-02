class Space::PageHierarchyForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  

  attr_reader :space, :page_hierarchy

  validate :completeness_of_page_hierarchy

  def initialize(space:, page_hierarchy:)
    @space = space
    @page_hierarchy = page_hierarchy
  end

  def save
    valid? && persist!
  end

  private

    def persist!
      UpdatePageHierarchy.call(page_hierarchy: page_hierarchy)
    end

    def completeness_of_page_hierarchy
      hierarchy_page_ids = []
      find_hierarchy_ids page_hierarchy, hierarchy_page_ids

      if hierarchy_page_ids.sort != space.pages.order(:id).pluck(:id)
        errors.add(:page_hierarchy, :invalid)
      end
    end

    def find_hierarchy_ids hierarchy, ids
      hierarchy.each do |entry|
        ids << entry[:id].to_i if entry[:id]
        find_hierarchy_ids(entry[:children], ids) if entry[:children]
      end
    end
end
