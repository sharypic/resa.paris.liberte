# List rooms and calendar
class CalendarsController < ApplicationController
  before_action :authenticate_resident!
  before_action :validate_room_id

  def index
  end

  private

  def validate_room_id
    redirect_to(rooms_path) unless Room.slug?(params[:room_slug])
  end
end
