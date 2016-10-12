# frozen_string_literal: true
# List show a calendar for a room type
class CalendarsController < ApplicationController
  include DateParser

  before_action :authenticate_resident!
  before_action :validate_room_slug

  # Nested below as get /rooms/:slug/calendars
  def index
    render locals: locals_for_index
  rescue MalformattedDateError
    redirect_to redirect_room_url, flash: { alert: t('errors.date.malformed') }
  rescue DayOffError
    redirect_to redirect_room_url, flash: { notice: t('errors.date.day_off') }
  end

  private

  def redirect_room_url
    opts = { room_slug: params[:room_slug] }.merge(date_to_param(default_date))
    room_calendars_path(opts)
  end

  def locals_for_index
    date = date_or_default(params)
    room = Room.class_for_slug(params[:room_slug])
    rooms = room.reservations_for_date(date)

    { date: date, room: room, rooms: rooms }
  end

  def validate_room_slug
    redirect_to(rooms_path) unless Room.slug?(params[:room_slug])
  end
end
