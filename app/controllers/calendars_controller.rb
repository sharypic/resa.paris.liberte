# List rooms and calendar
class CalendarsController < ApplicationController
  before_action :authenticate_resident!
  before_action :validate_room_id

  def index
    date_rendered = Date.today
    datetime_rendered = date_rendered.to_datetime

    render locals: {start_datetime: datetime_rendered + 8.hours,
                    end_datetime: datetime_rendered + 20.hours,
                    rooms: Room.class_for_slug(params[:room_slug]).all}
  end

  private

  def validate_room_id
    redirect_to(rooms_path) unless Room.slug?(params[:room_slug])
  end
end
