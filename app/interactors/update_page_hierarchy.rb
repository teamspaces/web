class UpdatePageHierarchy
  include Interactor

  def call
    page_hierarchy = context.page_hierarchy

    save_descendants(children: page_hierarchy)
  end

  private

    def save_descendants(parent_id: nil, children:)
      sort_order = 0

      children.each do |child_attributes|
        child_page = Page.find(child_attributes["id"])
        child_page.update(parent_id: parent_id, sort_order: sort_order)

        sort_order += 1

        if child_attributes["children"]
          save_descendants(parent_id: child_page.id, children: child_attributes["children"])
        end
      end
    end
end
