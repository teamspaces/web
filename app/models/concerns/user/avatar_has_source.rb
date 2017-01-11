module User::AvatarHasSource
  extend ActiveSupport::Concern

  class Avatar
    class Source
      GENERATED = "generated"
      SLACK     = "slack"
      UPLOADED  = "uploded"
    end
  end
end
