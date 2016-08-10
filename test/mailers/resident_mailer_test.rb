require 'test_helper'

class ResidentMailerTest < ActionMailer::TestCase
  fixtures :reservations

  test 'reservation_created' do
    reservation = reservations(:reservation_shed_1_hours)

    email = ResidentMailer.reservation_created(reservation)
    assert_equal [ENV['MAIL_FROM']], email.from
    assert_equal [reservation.resident.email], email.to

    assert_equal 'Hello', email.subject

    assert_equal 'MAILER.text', email.body.to_s
    assert_equal 'reservation_created.text.erb', email.body.to_s

    assert_equal 'MAILER.mjml', email.encoded.to_s
    assert_equal 'reservation_created.mjml.erb', email.encoded.to_s
  end
end
