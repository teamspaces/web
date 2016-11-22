class Slack::Api
  include Interactor

  attr_reader :token

  def call
    @token = context.token

    context.response = slack_api_get(context.ressource)
  end

  def slack_api_get(ressource, query_params = nil)
    url = "https://slack.com/api/#{ressource}?token=#{token}#{query_params}"
    HashWithIndifferentAccess.new(HTTParty.get(url))
  end
end
