Devise.setup do |config|
  config.omniauth :slack,
                  ENV["SLACK_OAUTH_CLIENT_ID"],
                  ENV["SLACK_OAUTH_CLIENT_SECRET"],
                  scope: 'identity.basic,identity.team,identity.avatar'
end
