class Slack::ParseToken
  include Interactor

  def call
    begin
      context.token = context.request.env["omniauth.auth"]["credentials"]["token"]
    rescue Exception
      context.fail!
    end
  end
end
