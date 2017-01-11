class LoginRegisterFunnel::BaseController::InvitationCookie

  COOKIE_NAME = :invitation_token

  def initialize(cookies)
    @cookies = cookies
  end

  def save(invitation)
    @cookies.signed[COOKIE_NAME] = invitation.token
  end

  def delete
    @cookies.delete COOKIE_NAME
  end

  def invitation
    invitation_token = @cookies.signed[COOKIE_NAME]
    Invitation.find_by(token: invitation_token)
  end
end
