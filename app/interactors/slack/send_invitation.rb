class Slack::SendInvitation
  include Rails.application.routes.url_helpers
  include Interactor

  attr_reader :invitation

  def call
    @invitation = context.invitation

    debugger

    send_invitation
  end

  def send_invitation
      client.chat_postMessage(
      channel: invitation.slack_id,
      text: "Hi #{invitation.first_name}, #{@invitation.user.first_name} invited you to collaborate on Spaces <#{landing_url(invitation_token: invitation.token)}|Join>",
      as_user: false)
  end

  def client
     Slack::Web::Client.new(token: "duroo-xoxp-12293384466-101666557111-106331497872-adef25eb780f75a212b6a45ce2934378")
  end

end
