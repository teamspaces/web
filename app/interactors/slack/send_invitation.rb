class Slack::SendInvitation
  include Interactor

  attr_reader :invitation, :invitation_url


  def call
    @invitation = context.invitation
    @invitation_url = context.invitation_url

    send_invitation
  end

  def send_invitation
    client.chat_postMessage(channel: invitation.slack_user_id,
                            text: invitation_text,
                            as_user: false,
                            username: "Spaces",
                            icon_url: "http://2.bp.blogspot.com/-xbfpggNA6iU/UvwAer0QKII/AAAAAAAAAGA/cKpUb3nXZpE/s1600/SpaceShipStill.png")
  end

  def invitation_text
    "Hi #{invitation.first_name}, #{@invitation.user.first_name} invited you to collaborate on Spaces <#{invitation_url}|Join>"
  end

  def client
    begin
      Slack::Web::Client.new(token: invitation.team.team_authentication.token)
    rescue
      context.fail!
    end
  end
end
