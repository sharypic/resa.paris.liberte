require 'test_helper'

class ResidentMailerTest < ActionMailer::TestCase
  fixtures :residents, :teams, :rooms
  setup do
    @reservation = Reservation.create!(name: 'reservation for email',
                                       starts_at: Time.zone.today,
                                       ends_at: Time.zone.today + 1.hour,
                                       resident: residents(:mfo),
                                       room: rooms(:shed))
  end

  test 'reservation_created have expected rendered info' do
    email = ResidentMailer.reservation_created(@reservation)

    assert_equal [ENV['MAIL_FROM']], email.from
    assert_equal [@reservation.resident.email], email.to

    assert_equal 'Hello', email.subject

    assert_match 'MAILER.mjml', email.encoded.to_s
    assert_match 'reservation_created.mjml.erb', email.encoded.to_s
  end

  test 'reservation_created includes .ical attachment' do
    email = ResidentMailer.reservation_created(@reservation)
    assert_equal 1, email.attachments.size
  end
end
