module Admin
  # list time account line consumptions
  class TimeAccountLinesController < Admin::ApplicationController
    before_action :set_team

    def index
      @time_account_lines = @team.time_account_lines
      @time_account_line = @team.time_account_lines.new(type: Credit.name)
    end

    def create
      amount = DatetimeHelper.half_hour_to_seconds(
        params[:credit][:amount].to_i
      )
      room_type = Room.class_for_string(params[:credit][:room_type])

      @team.account(room_type).credit(amount)
      redirect_to admin_team_time_account_lines_path(@team),
                  flash: { notice: 'Somme credité avec succès' }
    end

    private

    def set_team
      @team = Team.find(params[:team_id])
    end
  end
end
