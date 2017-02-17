class SpacesController < SubdomainBaseController
  before_action :set_space, only: [:show, :edit, :update, :destroy]
  layout 'client'

  # GET /spaces
  # GET /spaces.json
  def index
    @spaces = policy_scope(Space)
  end

  # GET /spaces/1
  # GET /spaces/1.json
  def show
    authorize @space, :show?
  end

  # GET /spaces/new
  def new
    @space_form = Space::Form.new(space: current_team.spaces.new)

    authorize @space_form.space, :new?
  end

  # GET /spaces/1/edit
  def edit
    @space_form = Space::Form.new(space: @space)

    authorize @space, :edit?
  end

  # POST /spaces
  # POST /spaces.json
  def create
    debugger
    @space_form = Space::Form.new(space: current_team.spaces.new,
                                  attributes: space_params)

    authorize @space_form.space, :create?

    respond_to do |format|
      if @space_form.save
        format.html { redirect_to space_pages_path(@space_form.space), notice: 'Space was successfully created.' }
        format.json { render :show, status: :created, location: @space_form.space }
      else
        format.html { render :new }
        format.json { render json: @space_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spaces/1
  # PATCH/PUT /spaces/1.json
  def update
    if params["space"]["pages_order"]

      def add_as_child(parent:,children:)
        children.each do |child_attributes|
          child_page = Page.find(child_attributes["id"])
          child_page.update(parent_id: parent.id)

          if child_attributes["children"]
            add_as_child(parent: child_page, children: child_attributes["children"])
          end
        end
      end

      JSON.parse(params["space"]["pages_order"]).each do |page_attributes|
        page = Page.find(page_attributes["id"])
        page.update(parent_id: nil)

        if page_attributes["children"]
          add_as_child(parent: page, children: page_attributes["children"])
        end
      end

      render :head
    else
      @space_form = Space::Form.new(space: @space, attributes: space_params)

      authorize @space, :update?

      respond_to do |format|
        if @space_form.save
          format.html { redirect_to @space_form.space, notice: 'Space was successfully updated.' }
          format.json { render :show, status: :ok, location: @space_form.space }
        else
          format.html { render :edit }
          format.json { render json: @space_form.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /spaces/1
  # DELETE /spaces/1.json
  def destroy
    authorize @space, :destroy?

    @space.destroy
    respond_to do |format|
      format.html { redirect_to spaces_url(@space.team), notice: 'Space was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_space
      @space = Space.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def space_params
      params.require(:space).permit(:name, :cover, :pages_order).to_h
    end
end
