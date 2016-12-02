class PageContentsController < ApplicationController
  before_action :set_page_content, only: [:show, :update]

  # GET /page_contents/1
  # GET /page_contents/1.json
  def show
    authorize @page_content, :show?
  end

  # PATCH/PUT /page_contents/1
  # PATCH/PUT /page_contents/1.json
  def update
    authorize @page_content, :update?

    respond_to do |format|
      if @page_content.update(page_content_params)
        format.html { redirect_to [@page_content], notice: 'Page Content was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_content }
      else
        format.json { render json: @page_content.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_content_params
      params.require(:page_content).permit(:contents)
    end

    def set_page_content
      @page_content = PageContent.find(params[:id])
    end
end
