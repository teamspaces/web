module User::AvatarHasSource
  extend ActiveSupport::Concern

  class Avatar
    class Source
      GENERATED = "generated"
      SLACK     = "slack"
      UPLOADED  = "uploded"
    end
  end

  def generated_avatar?
    avatar_source == Avatar::Source::GENERATED
  end

  def slack_avatar?
    avatar_source == Avatar::Source::SLACK
  end

  def uploaded_avatar?
    avatar_source == Avatar::Source::UPLOADED
  end

  def avatar_source
    avatar.metadata["source"]
  end
end
