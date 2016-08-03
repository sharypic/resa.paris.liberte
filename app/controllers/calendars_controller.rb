# List rooms and calendar
class CalendarsController < ApplicationController
  before_action :authenticate_resident!
  before_action :validate_room_id

  def index
    date_rendered = Date.today
    datetime_rendered = date_rendered.to_datetime
    starts_at = datetime_rendered + 8.hours
    ends_at = datetime_rendered + 20.hours

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
