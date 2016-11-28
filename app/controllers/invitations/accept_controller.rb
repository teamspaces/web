class Invitations::AcceptController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @invitation = Invitation.find_by(token: params[:token])
  end

end
