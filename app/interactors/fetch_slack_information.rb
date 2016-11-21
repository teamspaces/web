class FetchSlackInformation
  include Interactor

  def call
    @request = context.request

    context.token = token
    context.user = slack_user_information
    context.team_members = slack_members_information
  end

  private

    def slack_user_information
      user_id = slack_api_get("auth.test")[:user_id]
      slack_api_get("users.info", "&user=#{user_id}")[:user] #?[:ok] = true/false
    end

    def slack_members_information
      slack_api_get("users.list")[:members] #?[:ok] = true/false
    end

    def slack_api_get(method, query_params = nil)
      url = "https://slack.com/api/#{method}?token=#{token}#{query_params}"
      HashWithIndifferentAccess.new(HTTParty.get(url))
    end

    def token
      @request.env["omniauth.auth"]["credentials"]["token"]
    end
end
