module Admin
  # Access teams details
  class TeamsController < Admin::ApplicationController
    before_action :set_team, only: [:edit, :update, :destroy]

    # GET /teams
    def index
      @teams = Team.all
    end

    # GET /teams/new
    def new
      @team = Team.new
    end

    # GET /teams/1/edit
    def edit
    end

    # POST /teams
    def create
      @team = Team.new(team_params)

      if @team.save
        redirect_to admin_teams_url,
                    notice: 'Team was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /teams/1
    def update
      if @team.update(team_params)
        redirect_to admin_teams_url,
                    notice: 'Team was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /teams/1
    def destroy
      @team.destroy
      redirect_to admin_teams_url,
                  notice: 'Team was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name)
    end
  end
end
