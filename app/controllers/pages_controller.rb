class PagesController < SubdomainBaseController
  before_action :set_page,
                only: [:show, :edit, :update, :destroy]

  before_action :set_current_space,
                :set_sample_users_query,
                only: [:index, :show, :edit, :update, :create, :destroy]

  before_action :set_parent, only: [:create]

  before_action :set_search_query

  before_action :track_search,
                only: [:show]

  layout 'client'

  # GET /pages
  # GET /pages.json
  def index
    authorize current_space, :show?

    if current_space.root_page
      redirect_to current_space.root_page
    else
      @pages = policy_scope(Page).all
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

  # DELETE /pages/1(/:page_to_redirect_to_id)
  # DELETE /pages/1.json
  def destroy
    authorize @page, :destroy?

    redirect_path = path_to_redirect_to_after_page_deletion

    @page.destroy
    respond_to do |format|
      format.html { redirect_to redirect_path }
      format.json { head :no_content }
    end
  end

  # GET /page/search?q=bananas
  # GET /page/search.json?q=bananas
  def search
    @pages = Page.search(
        @search_query,
        fields: ["title^3", "contents"],
        misspellings: { below: 3, distance: 2 },
        routing: [current_team.id],
        track: { user_id: current_user.id },
        highlight: { fields: { title: {}, contents: { fragment_size: 200 } } },
        includes: [:space, :team],
        limit: 10
      )
  end

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

  helper_method :page_settings
  def page_settings
    PageSettingsHashPresenter.new(controller: self, page: @page)
                             .to_hash
                             .to_json
                             .html_safe
  end

  helper_method :page_hierarchy_settings
  def page_hierarchy_settings
    PageHierarchyHashPresenter.new(controller: self, space: current_space)
                              .to_hash
                              .to_json
                              .html_safe
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    def set_search_query
      @search_query = params[:q].to_s
    end

    def set_current_space
      @current_space = params[:space_id] ? Space.find(params[:space_id]) : @page.space
    end

    def set_parent
      @parent = current_space.pages.find_by(id: params[:parent_id])
    end

    def path_to_redirect_to_after_page_deletion
      Page::PathToRedirectToAfterDeletionInteractor.call(page_to_delete: @page,
                                                         page_to_redirect_to: Page.find_by_id(params[:page_to_redirect_to_id]),
                                                         controller: self).path
    end

    def track_search
      # Note: this strategy is OK for now but it means that if someone copies
      #   the page to a colleageue it will convert a second time. Same thing
      #   if the user goes back and reloads the page etc.
      #
      #   A better strategy would be to track the conversion when you click the
      #   URL under search results, before redirecting to the page.
      #
      search_id = params[:search_id]
      search = Searchjoy::Search.find_by(id: search_id)

      return unless search.present?

      logger.info "tracking conversion: id=#{search_id} convertable_type=#{@page.class.name} convertable_id=#{@page.id}"
      search.convert(@page)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :parent_id).to_h
    end

    def pundit_user
      PagePolicy::Context.new(current_user, current_team, current_space)
    end
end
