class Space::Cover::AttachUploadedCover
  include Interactor

  def call
    @space = context.space
    @file = context.file

    attach_uploaded_cover
  end

  private

    def attach_uploaded_cover
      @space.cover_attacher.context[:source] = Image::Source::UPLOADED
      @space.cover_attacher.assign(@file)
    end
end
