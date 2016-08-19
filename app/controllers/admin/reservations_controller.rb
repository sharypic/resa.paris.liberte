module Admin
  # list team reservations
  class ReservationsController < Admin::ApplicationController
    before_action :set_team
    include DateParser

    def index
      from_date = date_or_default(params, 'from_')
      to_date = date_or_default(params, 'to_')
      to_date = from_date + 1.week if from_date == to_date

      @reservations = @team.reservations.in_range((from_date..to_date))

      render locals: { from_date: from_date, to_date: to_date }
    end

    private

    def set_team
      @team = Team.find(params[:team_id])
    end
  end
end
