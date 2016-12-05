class Slack::SendInvitation
  include ActionView::Helpers::AssetUrlHelper
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
                            icon_url: url_to_image("SpaceShip.png"))
  end

  def invitation_text
    I18n.t('invitation.slack.text', invitee_first_name: invitation.first_name,
                                    host_first_name: @invitation.user.first_name,
                                    url: invitation_url)
  end

  def client
    begin
      Slack::Web::Client.new(token: invitation.team.team_authentication.token)
    rescue
      context.fail!
    end
  end
end
