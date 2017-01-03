class LandingController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def blank
    render plain: '<html><head><meta name="robots" content="noindex"></head><body></body></html>'
  end
end
