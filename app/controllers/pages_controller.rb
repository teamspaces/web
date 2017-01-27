class PagesController < SubdomainBaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_space, only: [:index, :new, :create]
  layout 'client'

  helper_method :render_hash_tree
  def render_hash_tree(tree)
    helpers.content_tag :ul do
      tree.each_pair do |node, children|
        if helpers.current_page?(node)
          content = helpers.link_to(node.title, node, class: "space-sidebar-active")
        else
          content = helpers.link_to(node.title, node)
        end
        content = helpers.content_tag(:h3, content.html_safe)

        content += render_hash_tree(children) if children.any?
        helpers.concat helpers.content_tag(:li, content.html_safe)

        if node.root?
          add_page_link = helpers.link_to('+ Add Page', new_space_page_path(node.space))
        else
          add_page_link = helpers.link_to('+ Add Page', new_space_page_path(node.space, parent_id: node.parent_id))
        end

        helpers.concat helpers.content_tag(:li, add_page_link.html_safe)
      end
    end
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
        format.html { redirect_to @page }
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
