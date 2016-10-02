class Slack::Identity
  attr_reader :token,
              :response

  def initialize(token)
    @token = token
  end

  def fetch
    url = build_api_url(token)
    @response = HTTParty.get(url)
  end

  def uid
    return nil unless success?
    build_uid
  end

  def success?
    response["ok"] == true
  end

  private

    def build_api_url(token)
      "https://slack.com/api/users.identity?token=#{token}"
    end

    # Implementaion copied from `omniauth-slack` gem.
    # Reference: https://github.com/kmrshntr/omniauth-slack/blob/master/lib/omniauth/strategies/slack.rb#L25
    #
    # We are doing this to avoid having to rely on omniauth in models that
    # otherwise just needs to interact with this class.
    def build_uid
      "#{response["user"]["id"]}-#{response["team"]["id"]}"
    end
end
