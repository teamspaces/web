module OmniAuth
  module Strategies
    class SlackInvitation < OmniAuth::Strategies::Slack
      option :name, 'slack_invitation'
    end
  end
end


Devise.setup do |config|
  config.omniauth :slack,
                  ENV["SLACK_OAUTH_CLIENT_ID"],
                  ENV["SLACK_OAUTH_CLIENT_SECRET"],
                  scope: 'identity.basic,identity.email,identity.team,identity.avatar'

  config.omniauth :slack_invitation,
                  ENV["SLACK_OAUTH_CLIENT_ID"],
                  ENV["SLACK_OAUTH_CLIENT_SECRET"],
                  scope: 'identity.basic,identity.email,identity.team,identity.avatar'
end
