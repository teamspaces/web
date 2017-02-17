class PageHierarchiesController < SubdomainBaseController
  before_action :set_space

  # DELETE /team/logo
  def update
    authorize @space, :update?

    UpdatePageHierarchy.call(hierarchy: page_hierarchy_params)

    render json: @space.pages.hash_tree, status: :ok
  end

  private

    def page_hierarchy_params
      JSON.parse(params["page_hierarchy"])
    end

    def set_space
      @space = Space.find(params[:space_id])
    end
end
