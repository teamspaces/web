module TeamSubdomainHandler
  extend ActiveSupport::Concern

  def current_team
    Team.find_by_name(request.subdomain)
  end
end
