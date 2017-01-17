class Team::Logo::AttachGeneratedLogo
  include Interactor

  def call
    @team = context.team

    attach_logo
  end

  def attach_logo
    logo_image = generated_logo_image

    @team.logo_attacher.context[:source] = Image::Source::GENERATED
    @team.logo_attacher.assign(logo_image)
  end

  private

    def generated_logo_image
      jpg_blob = Avatarly.generate_avatar(@team.name, { size: TeamLogo::SIZES.max, format: "jpg" })
      Shrine::FakeIO.new(jpg_blob, filename: "logo.jpg")
    end
end
