class LinkReferencesController  < ApplicationController
  before_action :set_page

  def create
     result = FindOrCreateLinkReferenceInteractor.call(link: params[:link], page: @page)

     render json: { linkReferences: @page.link_references.map { |link_reference| LinkReferenceSerializer.new(link_reference, {scope: self}) }}
  end

  private

    def set_page
      @page = Page.find(params[:page_id])
    end
end
