class PagesController < SubdomainBaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_space, :set_sample_users_query, only: [:index, :create, :show, :edit]
  before_action :set_parent, only: [:create]
  layout 'client'

  helper_method :number_of_words_to_minutes_reading
  def number_of_words_to_minutes_reading(number_of_words)
    reading_speed = 300
    minutes = (number_of_words / reading_speed).floor
    [minutes, 1].max
  end

  helper_method :editor_settings
  def editor_settings
    EditorSettingsHashPresenter
      .new(controller: self,
           user: current_user,
           page: @page)
      .to_hash
      .to_json
      .html_safe
  end

  helper_method :collab_url

  def collab_url
    EditorSettingsHashPresenter
      .new(controller: self,
           user: current_user,
           page: @page)
      .to_hash[:collab_url]
      .html_safe
  end

  # GET /pages
  # GET /pages.json
  def index
    @pages = policy_scope(Page).all
    authorize @pages, :index?

    if @pages.count.positive?
      redirect_to @pages.first
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    authorize @page, :show?
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
        format.html { redirect_to edit_page_path(@page) }
        format.json { render :show, status: :created, location: edit_page_path(@page) }
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
        format.html { redirect_to @page }
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
      @space = params[:space_id] ? Space.find(params[:space_id]) : @page.space
    end

    def set_sample_users_query
      @sample_users_query = SampleUsersQuery.new(resource: @space, total_users_to_sample: 3)
    end

    def set_parent
      @parent = @space.pages.find_by(id: params[:parent_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :parent_id).to_h
    end

    def pundit_user
      PagePolicy::Context.new(current_user, current_team, @space)
    end
end
