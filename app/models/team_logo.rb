class TeamLogo < SimpleDelegator

  SIZES = [192, 72, 48, 32, 24]

  class Source
    GENERATED = "generated"
    SLACK     = "slack"
    UPLOADED  = "uploaded"
  end

  def generated_avatar?
    logo_source == Source::GENERATED
  end

  def slack_avatar?
    logo_source == Source::SLACK
  end

  def uploaded_avatar?
    logo_source == Source::UPLOADED
  end

  def logo_source
    if logo
      metadata = logo.is_a?(Hash) ? logo["image_#{SIZES.max}".to_sym].metadata : logo.metadata
      metadata["source"]
    end
  end
end
