class LoginRegisterFunnel::EmailRegisterController < LoginRegisterFunnelController
  before_action :check_user_completed_preceding_funnel_steps

  def new
    @user = User.new(email: session[:user_email_address])
  end

  def create

  end

end
