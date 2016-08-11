# List rooms available to book
class RoomsController < ApplicationController
  include DatetimeHelper
  before_action :authenticate_resident!

  def index
    date = date_or_default
    render locals: { date: date }
  rescue ArgumentError
    redirect_to rooms_path
  end

  def date_or_default
    return date_from_param(params) if parse_date?
    Time.zone.today
  end

  def parse_date?
    [:year, :month, :day].all? { |key| params.key?(key) }
  end
end
