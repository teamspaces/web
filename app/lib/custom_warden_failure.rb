class CustomWardenFailure < Devise::FailureApp
  def redirect_url
    root_url(subdomain:  ENV["DEFAULT_SUBDOMAIN"])
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
