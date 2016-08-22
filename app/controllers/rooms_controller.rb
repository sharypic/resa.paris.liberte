# List rooms available to book
class RoomsController < ApplicationController
  include DateParser

  before_action :authenticate_resident!
  # before_action :poc_authenticate_resident!

  def index
    render locals: { date: date_or_default(params) }
  rescue MalformattedDateError
    redirect_to rooms_path, flash: { alert: t('errors.date.malformed') }
  rescue DayOffError
    redirect_to dated_rooms_path(date_to_param(default_date)),
                flash: { notice: t('errors.date.day_off') }
  end
end
