class Invitation::SlackInvitation::Send
  include Interactor
  include RouteHelper

  attr_reader :invitation

  def call
    @invitation = context.invitation

    send_invitation
  end

  def send_invitation
    begin
      client.chat_postMessage(channel: invitation.invited_slack_user_uid,
                              text: invitation_text,
                              as_user: false,
                              username: "Spaces",
                              icon_url: application_icon_url)
    rescue Slack::Web::Api::Error => exception
      Rails.logger.error("Invitation::SlackInvitation::Send#send_invitation failed with (#{exception.class}=#{exception.message})")
      Raven.capture_exception(exception)
      context.fail!
    end
  end

  private
    def invitation_text
      I18n.t("invitation.slack.text", invited_user_first_name: invitation.first_name,
                                      invited_by_user_first_name: invitation.invited_by_user.first_name,
                                      url: invitation_url)
    end

    def invitation_url
      accept_invitation_url(invitation.token, subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end

    def application_icon_url
      asset_url("assets/images/icons/space_ship.png", host: ActionController::Base.asset_host)
    end

    def client
      Slack::Web::Client.new(token: invitation.team.team_authentication.token)
    end
end
