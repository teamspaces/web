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
      expires_at: expires_at,
      page_content_url: @controller.page_content_url(@page.page_content),
      edit_page_url: @controller.edit_page_url(@page),
      csrf_token: @controller.view_context.form_authenticity_token
    }
  end

  private

    def payload
      {
        exp: expires_at,
        user_id: @user.id,
        collection: @collection,
        document_id: format_document_id
      }
    end

    def generate_token
      JWT.encode(payload, ENV["COLLAB_SERVICE_JWT_SECRET"], "HS256")
    end

    def expires_at
      Time.now.to_i + @expires_in.to_i.seconds
    end

    def format_document_id
      @page.id.to_s # integers not supported by sharedb so we're faking it
    end
end
