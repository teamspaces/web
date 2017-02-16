class EditorSettingsHashPresenter
  DEFAULT_COLLECTION = 'collab_pages'
  DEFAULT_EXPIRES_IN = ENV["EDITOR_SECONDS_TO_JWT_EXPIRY"] || 10.seconds

  def initialize(controller:, user:, page:, expires_in: DEFAULT_EXPIRES_IN, collection: DEFAULT_COLLECTION)
    @controller = controller
    @user = user
    @page = page
    @expires_in = expires_in
    @collection = collection
  end

  def to_hash
    {
      collection: @collection,
      document_id: format_document_id,
      collab_url: "#{ENV["COLLAB_SERVICE_URL"]}?token=#{generate_token}",
      page_content_url: @controller.page_content_url(@page.page_content),
      csrf_token: @controller.view_context.form_authenticity_token
    }
  end

  private

    def payload
      {
        exp: format_expires_in,
        user_id: @user.id,
        collection: @collection,
        document_id: format_document_id
      }
    end

    def generate_token
      JWT.encode(payload, ENV["COLLAB_SERVICE_JWT_SECRET"], "HS256")
    end

    def format_expires_in
      Time.now.to_i + @expires_in.to_i.seconds
    end

    def format_document_id
      @page.id.to_s # integers not supported by sharedb so we're faking it
    end
end
