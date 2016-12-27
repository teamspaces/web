module SubdomainHelper

  def url_options
    { domain: "lvh.me", port: Capybara.current_session.server.port }
  end
end
