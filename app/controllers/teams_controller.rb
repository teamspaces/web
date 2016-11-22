class TeamsController < SubdomainBaseController
  before_action :set_team, except: [:index]
  skip_before_action :check_team_membership, only: [:index, :create, :new, :update]

  # GET /teams
  # GET /teams.json
  def index
    @teams = policy_scope(Team)
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    authorize @team, :show?
  end

  # GET /teams/new
  def new
    @team_form = CreateTeamForUserForm.new
  end

  # GET /teams/1/edit
  def edit
    authorize @team, :edit?
  end

  # POST /teams
  # POST /teams.json
  def create
    @team_form = CreateTeamForUserForm.new(create_team_for_user_form_params.to_h
                                           .merge(user: current_user))

    respond_to do |format|
      if @team_form.save
        format.html { redirect_to team_url(subdomain: @team_form.team.subdomain, auth_token: GenerateLoginToken.call(user: current_user)), notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team_form.team }
      else
        format.html { render :new }
        format.json { render json: @team_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    authorize @team, :update?

    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to team_url(subdomain: @team.subdomain, auth_token: GenerateLoginToken.call(user: current_user)), notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    authorize @team, :destroy?

    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url(subdomain: ""), notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = current_team
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :subdomain)
    end

    def create_team_for_user_form_params
      params.require(:create_team_for_user_form)
            .permit(:name, :subdomain)
    end
end
