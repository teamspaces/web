class LoginRegisterFunnel::SlackLoginRegisterController < ApplicationController
  skip_before_action :authenticate_user!

  def login

  end

  def register

  end

end
