class LandingController < ApplicationController
  def index
    @invitation_token = params[:invitation_token]
  end
end
