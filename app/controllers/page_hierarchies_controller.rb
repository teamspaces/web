class PageHierarchiesController < SubdomainBaseController
  before_action :set_space

  # PATCH /spaces/:space_id/page_hierarchy
  def update
    authorize @space, :update?

    hierarchy_form = Space::PageHierarchyForm.new(space: @space,
                                                  page_hierarchy: page_hierarchy_params)

    if hierarchy_form.save
      render json: @space.pages.hash_tree, status: :ok
    else
      render json: hierarchy_form.errors, status: :unprocessable_entity
    end
  end

  private

    def set_space
      @space = Space.find(params[:space_id])
    end

    def page_hierarchy_params
      params[:page_hierarchy]
    end
end
