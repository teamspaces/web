Devise.setup do |config|
  config.omniauth :slack,
                  ENV["SLACK_OAUTH_CLIENT_ID"],
                  ENV["SLACK_OAUTH_CLIENT_SECRET"],
                  #scope: 'users:read'
                  scope: 'identity.basic,identity.email,identity.team,identity.avatar'
end
