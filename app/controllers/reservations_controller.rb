# Allow a signed in user to book a reservation in a room
class ReservationsController < ApplicationController
  include DatetimeHelper

  before_action :authenticate_resident!, except: %i(show)
  before_action :validate_room_id, except: %i(show)

  # Nested below as get /rooms/:id/reservations/:id
  # Used by popover via ajax request
  def show
    if resident_signed_in?
      render layout: false,
             locals: { reservation: Reservation.find(params[:id]),
                       room: Room.find(params[:room_id]) }
    else
      render nothing: true, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    render nothing: true, status: :bad_request
  end

  # rubocop:disable Metrics/AbcSize
  def destroy
    reservation = Reservation.find(params[:id])
    opts = { room_slug: @room.to_slug }
    opts = opts.merge(date_to_param(reservation.starts_at))

    redirect_to room_calendars_path(opts),
                flash: destroy_reservation_with_flash(reservation)
  rescue ActiveRecord::RecordNotFound
    redirect_to room_calendars_path({ room_slug: @room.to_slug }
                                    .merge(date_to_param(Time.zone.today)))
  end
  # rubocop:enable Metrics/AbcSize

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

    if DebitReservation.new(reservation).create
      opts = { room_slug: reservation.room.to_slug }
      opts = opts.merge(date_to_param(reservation.starts_at))

      redirect_to room_calendars_path(opts)
    else
      render :new, locals: { reservation: reservation }
    end
  end

  private

  def destroy_reservation_with_flash(reservation)
    if reservation.destroyable?
      { alert: t('.time_error') }
    elsif reservation.destroy
      { notice: t('.success') }
    else
      { alert: t('.error') }
    end
  end

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
