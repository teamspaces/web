class CustomSlackClient < Slack::Web::Client

  def initialize(opts={})
    super(opts)
  end

  def post(path, options = {})
    APICache.get(path) do
      super(path,options)
    end
  end

end
