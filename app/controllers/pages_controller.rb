class PagesController < SubdomainBaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_space, only: [:index, :new, :create]

  # TODO: Move this into
  # EditorSettingsHashPresenter.new(user_id: current_user.id, ...)
  def editor_settings(user_id, collection, document_id)
    payload = {
      exp: (Time.now.to_i + 10),
      user_id: user_id,
      collection: 'collab_pages',
      document_id: document_id.to_s
    }

    token = JWT.encode(payload, ENV["COLLAB_SERVICE_JWT_SECRET"], 'HS256')

    {
      collection: collection,
      document_id: document_id.to_s,
      collab_url: "#{ENV["COLLAB_SERVICE_URL"]}?token=#{token}",
    }.to_json.html_safe
  end
  helper_method :editor_settings

  # GET /pages
  # GET /pages.json
  def index
    @pages = policy_scope(Page).all
    authorize @pages, :index?
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    authorize @page, :show?
  end

  # GET /pages/new
  def new
    @page = policy_scope(Page).build
    authorize @page, :new?
  end

  # GET /pages/1/edit
  def edit
    authorize @page, :edit?
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = policy_scope(Page).new(page_params)
    authorize @page, :create?

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    authorize @page, :update?

    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to [@page], notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    authorize @page, :destroy?

    @page.destroy
    respond_to do |format|
      format.html { redirect_to space_pages_path(@page.space), notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    def set_space
      @space = Space.find(params[:space_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title)
    end

    def pundit_user
      PagePolicy::Context.new(current_user, current_team, @space)
    end
end
