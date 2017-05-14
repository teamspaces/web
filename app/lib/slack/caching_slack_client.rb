class CachingSlackClient < Slack::Web::Client

  attr_reader :caching_options

  def initialize(opts={})
    @caching_options = {
      cache: 600,    # 10 minutes  After this time fetch new data
      valid: 86400,  # 1 day       Maximum time to use old data
                        #             :forever is a valid option
      period: 0,     # 0 second    Maximum frequency to call API
      timeout: 5     # 5 seconds   API response timeout
    }

    super(opts)
  end

  def get(path, options={})
    APICache.get(path, caching_options) do
      super(path,options)
    end
  end

  def post(path, options={})
    APICache.get(path, caching_options) do
      super(path,options)
    end
  end
end
