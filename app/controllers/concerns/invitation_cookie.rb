module InvitationCookie
  extend ActiveSupport::Concern

  def set_invitation_cookie_from_params
    if params[:invitation_token]
      cookies.signed[:invitation_token] = { value: params[:invitation_token],
                                            domain: :all, tld_length: 2,
                                            expires: 1.hour.from_now }
    end
  end

  def invitation_cookie
    cookies.signed[:invitation_token]
  end

  def destroy_invitation_cookie
    cookies.delete :invitation_token, domain: :all, tld_length: 2
  end
end
