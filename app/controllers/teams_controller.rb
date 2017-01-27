class TeamsController < SubdomainBaseController
  before_action :set_team, except: [:index]
  skip_before_action :verify_team_membership, only: [:index, :create, :new, :update]
  layout 'client'

  # GET /teams/1
  # GET /teams/1.json
  def show
    authorize @team, :show?
  end

  # GET /teams/1/edit
  def edit
    authorize @team, :edit?

    @team_form = Team::Form.new(team: @team)
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    authorize @team, :update?

    @team_form = Team::Form.new(team: @team, params: team_params)

    respond_to do |format|
      if @team_form.save
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
      format.html { redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), notice: 'Team was successfully destroyed.' }
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
      params.require(:team).permit(:name, :logo).to_h
    end
end
