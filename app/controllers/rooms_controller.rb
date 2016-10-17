# List rooms available to book
class RoomsController < ApplicationController
  include DateParser

  before_action :authenticate_resident!

  def index
    date = date_or_default(params)
    weekly_team_reservations = current_resident.team.weekly_reservations(date)

    render locals: { date: date,
                     weekly_team_reservations: weekly_team_reservations }
  rescue MalformattedDateError
    redirect_to rooms_path, flash: { alert: t('errors.date.malformed') }
  rescue DayOffError
    redirect_to dated_rooms_path(date_to_param(default_date)),
                flash: { notice: t('errors.date.day_off') }
  end
end
