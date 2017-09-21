class PingsController < ActionController::Base
  skip_before_action :verify_authenticity_token, only: [:show]

  def show
    render plain: "pong"
  end
end
