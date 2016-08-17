module Admin
  # list time account line consumptions
  class TimeAccountLinesController < Admin::ApplicationController
    before_action :set_team

    def index
      @time_account_lines = @team.time_account_lines
    end

    private

    def set_team
      @team = Team.find(params[:team_id])
    end
  end
end
