class PageContentsController < SubdomainBaseController
  before_action :set_page_content

  # GET /page_contents/1
  # GET /page_contents/1.json
  def show
    authorize @page_content.page, :show?
  end

  # PATCH/PUT /page_contents/1
  # PATCH/PUT /page_contents/1.json
  def update
    authorize @page_content.page, :update?

    respond_to do |format|
      if @page_content.update(page_content_params)
        format.json { render :show, status: :ok, location: @page_content }
      else
        format.json { render json: @page_content.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_content_params
      params.require(:page_content).permit(:contents).to_h
    end

    def set_page_content
      @page_content = PageContent.find(params[:id])
    end

    def pundit_user
      PagePolicy::Context.new(current_user, current_team)
    end
end
