class TeamLogoUploader < BaseUploader

  def process(io, context)
    case context[:phase]
      when :store
        ImageVersionsGenerator.call(io: io, sizes: TeamLogo::SIZES).versions
    end
  end
end
