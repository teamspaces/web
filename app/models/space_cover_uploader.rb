class SpaceCoverUploader < BaseUploader

  def process(io, context)
    case context[:phase]
      when :store
        ImageVersionsGenerator.call(io: io, sizes: SpaceCover::SIZES).versions
    end
  end
end
