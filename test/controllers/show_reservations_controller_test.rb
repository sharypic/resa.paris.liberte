require 'test_helper'

class CreateReservationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents, :rooms

  test 'responds with nothing and 403 status when not signed in' do
    get room_reservation_path(room_id: 1, id: 1, format: :html),
        xhr: true
    assert_response :forbidden
  end

  test 'responds with nothing and 400 when room_id or reservation_id bad' do
    resident = residents(:mfo)
    room = rooms(:shed)
    sign_in(resident)
    reservation = Reservation.create!(starts_at: Time.zone.today + 8.hours,
                                      ends_at: Time.zone.today + 9.hours,
                                      name: 'mouf',
                                      room: room,
                                      resident: resident)

    get room_reservation_path(room_id: room.id, id: 'A', format: :html),
        xhr: true
    assert_response :bad_request

    get room_reservation_path(room_id: 'A', id: reservation.id, format: :html),
        xhr: true
    assert_response :bad_request
  end

  test 'renders partial on logged with valid params' do
    resident = residents(:mfo)
    room = rooms(:shed)
    sign_in(resident)
    reservation = Reservation.create!(starts_at: 8.hours.from_now.utc,
                                      ends_at: 9.hours.from_now.utc,
                                      name: 'mouf',
                                      room: room,
                                      resident: resident)

    get room_reservation_path(room_id: room.id,
                              id: reservation.id,
                              format: :html),
        xhr: true

    assert_response :success

    team_name = reservation.team.name

    assert_select 'li.reservation-team-name',
                  I18n.t('reservations.show.team', team_name: team_name),
                  'Missing team name'
    user_name = reservation.resident.fullname
    assert_select 'li.reservation-resident-fullname',
                  I18n.t('reservations.show.user', user_name: user_name),
                  'Missing resident name'
    destroy_url = room_reservation_path(room_id: reservation.room.id,
                                        id: reservation.id)
    assert_select "a.btn-danger[href='#{destroy_url}']",
                  I18n.t('reservations.show.destroy'),
                  'missing link'
  end
end
