require 'test_helper'

class CreateReservationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents, :rooms

  test 'responds with nothing and 403 status when not signed in' do
    xhr :get, room_reservation_path(room_id: 1, id: 1)
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

    xhr :get, room_reservation_path(room_id: room.id, id: 'A')
    assert_response :bad_request

    xhr :get, room_reservation_path(room_id: 'A', id: reservation.id)
    assert_response :bad_request
  end

  test 'renders partial on logged with valid params' do
    resident = residents(:mfo)
    room = rooms(:shed)
    sign_in(resident)
    reservation = Reservation.create!(starts_at: Time.zone.today + 8.hours,
                                      ends_at: Time.zone.today + 9.hours,
                                      name: 'mouf',
                                      room: room,
                                      resident: resident)

    xhr :get, room_reservation_path(room_id: room.id, id: reservation.id)
    assert_response :success
    assert_select '.reservation-team-name',
                  reservation.team.name,
                  'Missing team name'
    assert_select '.reservation-resident-fullname',
                  reservation.resident.fullname,
                  'Missing resident name'
    assert_select '.reservation-edit',
                  'Edit',
                  'missing edit link'
  end
end
