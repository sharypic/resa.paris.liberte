module Admin
  # list team reservations
  class ReservationsController < Admin::ApplicationController
    before_action :set_team

    def index
      @reservations = @team.reservations
    end

    private

    def set_team
      @team = Team.find(params[:team_id])
    end
  end
end
