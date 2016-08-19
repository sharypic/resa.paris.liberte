module Admin
  # CRUD for admin residents
  class ResidentsController < Admin::ApplicationController
    before_action :set_team
    before_action :set_resident, only: [:edit, :update, :destroy]
    include DateParser

    # GET /residents
    def index
      from_date = date_or_default(params, 'from_')
      to_date = date_or_default(params, 'to_')
      to_date = from_date + 1.week if from_date == to_date

      @residents = @team.residents

      render locals: { from_date: from_date, to_date: to_date }
    end

    # GET /residents/new
    def new
      @resident = @team.residents.new
    end

    # GET /residents/1/edit
    def edit
    end

    # POST /residents
    def create
      @resident = @team.residents.new(resident_params)

      if @resident.save
        redirect_to admin_team_residents_path(@resident.team),
                    notice: 'Resident was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /residents/1
    def update
      if @resident.update(resident_params)
        redirect_to admin_team_residents_path(@resident.team),
                    notice: 'Resident was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /residents/1
    def destroy
      @resident.destroy
      redirect_to admin_team_residents_url(@team),
                  notice: 'Resident was successfully destroyed.'
    end

    private

    def set_team
      @team = Team.find(params[:team_id])
    end

    def set_resident
      @resident = @team.residents.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def resident_params
      white_list = %i(email firstname lastname admin team_id)
      white_list.push(:password) if action_name == 'create'
      params.require(:resident).permit(*white_list)
    end
  end
end
