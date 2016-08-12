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

  # rubocop:disable Metrics/LineLength
  test 'reservation_created have expected rendered info' do
    email = ResidentMailer.reservation_created(@reservation)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ENV['MAIL_FROM']], email.from
    assert_equal [@reservation.resident.email], email.to
    assert_equal I18n.t('mail.reservation_created.subject', reservation_name: @reservation.name),
                 email.subject,
                 'wrong subject'

    assert_select_email do
      assert_select :td, text: I18n.t('mail.reservation_created.body.when.value',
                                      date: I18n.l(@reservation.starts_at,
                                                   format: :YMD_with_text),
                                      starts_at: I18n.l(@reservation.starts_at,
                                                        format: :hours_minutes),
                                      ends_at: I18n.l(@reservation.ends_at,
                                                      format: :hours_minutes))
      assert_select :td, text: I18n.t('mail.reservation_created.body.where.value',
                                      room_name: @reservation.room.name)
      assert_select :div, text: I18n.t('mail.reservation_created.body.cta.download_ics')
      assert_select :div, text: I18n.t('mail.reservation_created.body.cta.delete_reservation.label')
      assert_select :td, text: I18n.t('mail.reservation_created.body.cta.delete_reservation.button')
      reservation_url = room_calendars_url(
        { room_slug: @reservation.room.to_slug }
        .merge(date_to_param(@reservation.starts_at))
      )
      assert_select "a[href='#{reservation_url}']", text: I18n.t('mail.reservation_created.body.cta.delete_reservation.button')
    end
  end
  # rubocop:enable Metrics/LineLength

  test 'reservation_created includes .ical attachment' do
    email = ResidentMailer.reservation_created(@reservation)
    assert_equal 1, email.attachments.size
  end
end
