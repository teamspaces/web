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
    @space = policy_scope(Space).build
    authorize @space, :new?
  end

  # GET /spaces/1/edit
  def edit
    authorize @space, :edit?
  end

  # POST /spaces
  # POST /spaces.json
  def create
    @space = policy_scope(Space).new(space_params)

    authorize @space, :create?

    respond_to do |format|
      if @space.save
        format.html { redirect_to space_pages_path(@space), notice: 'Space was successfully created.' }
        format.json { render :show, status: :created, location: @space }
      else
        format.html { render :new }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spaces/1
  # PATCH/PUT /spaces/1.json
  def update
    authorize @space, :update?

    respond_to do |format|
      if @space.update(space_params)
        format.html { redirect_to @space, notice: 'Space was successfully updated.' }
        format.json { render :show, status: :ok, location: @space }
      else
        format.html { render :edit }
        format.json { render json: @space.errors, status: :unprocessable_entity }
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
      params.require(:space).permit(:name)
    end
end
