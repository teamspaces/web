class LoginRegisterFunnel::TeamsController < LoginRegisterFunnelController
  before_action :authenticate_user!
  before_action :force_user_to_be_on_default_subdomain
  after_action :sign_out_user_on_default_subdomain

  def new

  end

  def create

  end

  def show

  end

  def index

  end

  private

    def force_user_to_be_on_default_subdomain

    end

    def sign_out_user_on_default_subdomain

    end
end
