class Team::Logo::AttachUploadedLogo
  include Interactor

  def call
    @team = context.team
    @file = context.file

    attach_uploaded_logo
  end

  private

    def attach_uploaded_logo
      @team.logo_attacher.context[:source] = Image::Source::UPLOADED
      @team.logo_attacher.assign(@file)
    end
end
