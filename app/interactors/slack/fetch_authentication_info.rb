class Slack::FetchAuthenticationInfo
  include Interactor

  attr_reader :token

  def call
    @token = context.token

    context.authentication_info = fetch_authentication_info
    context.fail! unless context.authentication_info
  end

  def fetch_authentication_info
    begin
      info = Slack::Web::Client.new(token: context.token).auth_test
      return info if info.ok

      Rails.logger.error "Slack::FetchAuthenticationInfo#fetch_authentication_info failed token=#{context.token}, identity=#{identity.inspect}"
      return nil
    rescue => exception
      Rails.logger.error "Slack::FetchAuthenticationInfo#fetch_authentication_info token=#{context.token} raised #{exception.class}: #{exception.message}"
      return nil
    end
  end
end
