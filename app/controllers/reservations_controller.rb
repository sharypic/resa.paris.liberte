# Allow a signed in user to book a reservation in a room
class ReservationsController < ApplicationController
  include DatetimeHelper

  before_action :authenticate_resident!
  before_action :validate_room_id

  # Nested below as get /rooms/:id/reservations/new
  def new
    render locals: {
      reservation: current_resident.reservations.new(
        room_id: @room.id,
        starts_at: datetime_from_param(params)
      )
    }
  end

  # Nested below as get /rooms/:id/reservations
  def create
    reservation = current_resident.reservations.new(reservation_attributes)

    if reservation.save
      opts = { room_slug: reservation.room.to_slug }
      opts = opts.merge(date_to_param(reservation.starts_at))

      redirect_to room_calendars_path(opts)
    else
      render :new, locals: { reservation: reservation }
    end
  end

  private

  def reservation_attributes
    permitted = %i(
      name
      room_id
      starts_at(1i) starts_at(2i) starts_at(3i) starts_at(4i) starts_at(5i)
      ends_at(1i) ends_at(2i) ends_at(3i) ends_at(4i) ends_at(5i)
    )
    params.require(:reservation).permit(permitted)
  end

  def validate_room_id
    @room = Room.find(params[:room_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to(rooms_path)
  end
end
