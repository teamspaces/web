Devise.setup do |config|
  config.omniauth :slack,
                  ENV["SLACK_OAUTH_CLIENT_ID"],
                  ENV["SLACK_OAUTH_CLIENT_SECRET"],
                  scope: 'identity.basic,identity.email,identity.team,identity.avatar'

  config.omniauth :slack_button,
                  ENV["SLACK_OAUTH_CLIENT_ID"],
                  ENV["SLACK_OAUTH_CLIENT_SECRET"],
                  scope: 'users:read,chat:write:bot,commands'
end
