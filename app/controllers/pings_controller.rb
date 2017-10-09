class PingsController < ActionController::Base
  def show
    render plain: "pong"
  end
end
