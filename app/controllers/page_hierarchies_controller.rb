class PageHierarchiesController < SubdomainBaseController
  before_action :set_space

  # DELETE /team/logo
  def update
    authorize @space, :update?


    def save_children(parent:,children:)
      children_sort = 0

      children.each do |child_attributes|
        child_page = Page.find(child_attributes["id"])
        child_page.update(parent_id: parent&.id, sort_order: children_sort)

        children_sort += 1

        if child_attributes["children"]
          save_children(parent: child_page, children: child_attributes["children"])
        end
      end
    end

    save_children(parent: nil, children: pages_order_params)


    render json: @space.pages.hash_tree, status: :ok
  end

  private

    def pages_order_params
      JSON.parse(params["page_hierarchy"])
    end

    def set_space
      @space = Space.find(params[:space_id])
    end
end
