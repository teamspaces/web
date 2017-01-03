class LandingController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def blank
    render plain: '<meta name="robots" content="noindex">'
  end
end
