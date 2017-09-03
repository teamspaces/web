class LinkReferencesController  < ApplicationController
  def create
     debugger

     puts params
     puts params[:link]

     render json: { linkReference: { id: 4, text: "YES" } }
  end
end
