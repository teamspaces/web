class RootSubdomainController < SubdomainBaseController
  def index
    case current_team.spaces.count
    when 0
      redirect_to new_space_path
    when 1
      redirect_to space_pages_path(current_team.spaces.first)
    else
      redirect_to spaces_path
    end
  end
end
