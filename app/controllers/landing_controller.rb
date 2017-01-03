class LandingController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def blank
    render html: '<html><head><meta name="robots" content="noindex"></head><body></body></html>'.html_safe
  end
end
