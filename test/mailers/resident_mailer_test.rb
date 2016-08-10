require 'test_helper'

class ResidentMailerTest < ActionMailer::TestCase
  fixtures :residents, :teams, :rooms

  test 'reservation_created' do
    resident = residents(:mfo)
    reservation = Reservation.create!(name: 'reservation for email',
                                      starts_at: Time.zone.today,
                                      ends_at: Time.zone.today + 1.hour,
                                      resident: resident,
                                      room: rooms(:shed))

    email = ResidentMailer.reservation_created(reservation)
    assert_equal [ENV['MAIL_FROM']], email.from
    assert_equal [reservation.resident.email], email.to

    assert_equal 'Hello', email.subject

    assert_match 'MAILER.mjml', email.encoded.to_s
    assert_match 'reservation_created.mjml.erb', email.encoded.to_s
  end
end
