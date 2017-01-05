class LandingController < ApplicationController
  include SignedInUsersCookie
  skip_before_action :authenticate_user!

  def index
    @teams = signed_in_users_cookie_teams
  end

  def blank
    render html: '<html><head><meta name="robots" content="noindex"></head><body></body></html>'.html_safe
  end
end
