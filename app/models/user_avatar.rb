class UserAvatar < SimpleDelegator

  SIZES = [1024, 192, 72, 48, 32, 24]

  class Source
    GENERATED = "generated"
    SLACK     = "slack"
    UPLOADED  = "uploaded"
  end

  def generated_avatar?
    avatar_source == Source::GENERATED
  end

  def slack_avatar?
    avatar_source == Source::SLACK
  end

  def uploaded_avatar?
    avatar_source == Source::UPLOADED
  end

  def avatar_source
    if avatar
      metadata = avatar.is_a?(Hash) ? avatar["image_#{SIZES.max}".to_sym].metadata : avatar.metadata
      metadata["source"]
    end
  end
end
