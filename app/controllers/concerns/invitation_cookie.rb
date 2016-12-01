module InvitationCookie
  extend ActiveSupport::Concern

  def set_invitation_cookie
    if params[:invitation_token]
      cookies.signed[:invitation_token] = { value: params[:invitation_token] }
    end
  end

  def invitation_cookie
    cookies.signed[:invitation_token]
  end

  def destroy_invitation_cookie
    cookies.delete :invitation_token
  end
end
