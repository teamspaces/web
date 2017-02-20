class PageHierarchiesController < SubdomainBaseController
  before_action :set_space

  # PATCH /spaces/:space_id/page_hierarchy
  def update
    authorize @space, :update?

    UpdatePageHierarchy.call(hierarchy: page_hierarchy_params)

    render json: @space.pages.hash_tree, status: :ok
  end

  private

    def set_space
      @space = Space.find(params[:space_id])
    end

    def page_hierarchy_params
      params["page_hierarchy"]
    end
end
