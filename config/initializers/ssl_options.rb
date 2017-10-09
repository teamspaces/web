# Be sure to restart your server when you modify this file.

# Configure SSL options to enable HSTS with subdomains.
Rails.application.config.ssl_options = {

  hsts: { subdomains: true },

  # SSL Termination is done on load balancer which means that
  # requests to check the status will be done with HTTP on port 80.
  redirect: {
    exclude: -> request { request.path =~ /_ping/ }
  }
}
