# List show a calendar for a rom type
class CalendarsController < ApplicationController
  before_action :authenticate_resident!
  before_action :validate_room_id

  def index
    date = Time.zone.today
    starts_at = date + 8.hours
    ends_at = date + 20.hours

    rooms = Room.class_for_slug(params[:room_slug])
                .reservations_in(starts_at, ends_at)

    render locals: { start_datetime: starts_at,
                     end_datetime: ends_at,
                     rooms: rooms }
  end

  private

  def validate_room_id
    redirect_to(rooms_path) unless Room.slug?(params[:room_slug])
  end
end
