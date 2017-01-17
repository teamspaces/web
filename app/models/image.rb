class Image

  def initialize(image)
    @image = image
  end

  def generated?
    source == Source::GENERATED
  end

  def slack?
    source == Source::SLACK
  end

  def uploaded?
    source == Source::UPLOADED
  end

  def source
    if @image
      metadata = @image.is_a?(Hash) ? @image[@image.keys.first].metadata : @image.metadata
      metadata["source"]
    end
  end
end
