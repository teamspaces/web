class SpaceCoverUploader < BaseUploaders

  def generate_location(io, context)
    type  = "space_cover"
    version = context[:version] if context[:version]
    name  = super # the default unique identifier

    [type, version, name].compact.join("/")
  end

  def process(io, context)
    case context[:phase]
      when :store
        ImageVersionsGenerator.call(io: io, sizes: SpaceCover::SIZES).versions
    end
  end

  add_metadata :source do |io, context|
    context[:source] || context[:record][:cover_data]["metadata"]["source"]
  end

  Attacher.default_url do |options|
    "default_cover.jpg"
  end
end
