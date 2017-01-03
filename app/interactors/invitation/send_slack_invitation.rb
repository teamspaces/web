class Invitation::SendSlackInvitation
  include Interactor
  include RouteHelper

  attr_reader :invitation

  def call
    @invitation = context.invitation

    send_invitation
  end

  def send_invitation
    begin
      client.chat_postMessage(channel: invitation.slack_user_id,
                              text: invitation_text,
                              as_user: false,
                              username: "Spaces",
                              icon_url: url_to_image("SpaceShip.png"))
    rescue Slack::Web::Api::Error => exception
      Rails.logger.error("Invitation::SendSlackInvitation#send_invitation failed with (#{exception.class}=#{exception.message})")
      Raven.capture_exception(exception)
      context.fail!
    end
  end

  private
    def invitation_text
      invitation_url = accept_invitation_url(invitation.token, subdomain: ENV["DEFAULT_SUBDOMAIN"])

      I18n.t('invitation.slack.text', invitee_first_name: invitation.first_name,
                                      host_first_name: invitation.user.first_name,
                                      url: invitation_url)
    end

    def client
      Slack::Web::Client.new(token: invitation.team.team_authentication.token)
    end
end
