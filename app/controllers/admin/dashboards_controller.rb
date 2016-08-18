module Admin
  # uniq interface to manage them all
  class DashboardsController < Admin::ApplicationController
    def index
      redirect_to admin_teams_path
    end
  end
end
