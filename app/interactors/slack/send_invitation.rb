class Slack::SendInvitation
  include Rails.application.routes.url_helpers
  include Interactor

  attr_reader :invitation, :host

  def call
    @invitation = context.invitation
    @host = context.host

    send_invitation
  end

  def send_invitation
    client.chat_postMessage(channel: invitation.slack_id, text: invitation_text, as_user: false)
  end

  def invitation_text
    "Hi #{invitation.first_name}, #{@invitation.user.first_name} invited you to collaborate on Spaces <#{invitation_url}|Join>"
  end

  def invitation_url
    landing_url(subdomain: "", host: host, invitation_token: invitation.token)
  end

  def client

  end
end
