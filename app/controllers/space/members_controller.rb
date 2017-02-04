class Space::MembersController < SubdomainBaseController
  before_action :set_space
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
    @space_form = Space::Form.new(space: policy_scope(Space).build)

    authorize @space_form.space, :new?
  end

  # GET /spaces/1/edit
  def edit
    @space_form = Space::Form.new(space: @space)

    authorize @space_form.space, :edit?
  end

  # POST /spaces
  # POST /spaces.json
  def create
    @space_form = Space::Form.new(space: policy_scope(Space).build, params: space_params)

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
    @space_form = Space::Form.new(space: @space, params: space_params)

    authorize @space_form.space, :update?

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
      @space = Space.find(params[:space_id])
    end
end
