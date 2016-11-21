Rails.application.configure do
  config.action_mailer.default_url_options = { host: ENV["ACTION_MAILER_HOST"] }

  if ENV["SMTP_ENABLED"] == "true"
    config.action_mailer.smtp_settings = {
      user_name: ENV["SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"],
      address: ENV["SMTP_ADDRESS"],
      domain:  ENV["SMTP_DOMAIN"],
      port: ENV["SMTP_PORT"],
      authentication: ENV["SMTP_AUTHENTICATION"],
      enable_starttls_auto: ENV["SMTP_ENABLE_STARTTLS_AUTO"] == 'true'
    }
  end
end
