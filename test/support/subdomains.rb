def use_subdomain(subdomain)
  hostname = subdomain ? "#{subdomain}.lvh.me" : "lvh.me"
  Capybara.app_host = "http://#{hostname}"
end

def reset_subdomain!
  use_subdomain(ENV["DEFAULT_SUBDOMAIN"])
end

Capybara.configure do |config|
  config.default_host = "http://#{ENV["DEFAULT_SUBDOMAIN"]}.lvh.me"
  config.always_include_port = true
end

reset_subdomain!
