require 'test_helper'

class RoomsHelperTest < ActionView::TestCase
  include DatetimeHelper

  setup do
    @room = Shed.new
    @date = Time.zone.today
  end

  # test '.block_free_seconds_per_week' do
  # end

  test '.progress' do
    fragment = node(progress_bar(10))

    assert_select fragment, 'div.progress' do
      assert_select "div.progress-bar[style='width: 10%;']"
    end
  end

  test '.label_half_hours_available with free time' do
    fragment = node(label_half_hours_available(30.minutes.to_i, :free))

    assert_select fragment,
                  'p.notice-progress-consumption',
                  '1 demi-heure gratuite restante cette semaine'
  end

  test '.label_half_hours_available with free paid' do
    fragment = node(label_half_hours_available(30.minutes.to_i, :paid))

    assert_select fragment,
                  'p.notice-progress-consumption',
                  '1 demi-heure payante restante'
  end

  test '.link_to_free_booking with credits > 30.minutes' do
    url_opts = { room_slug: @room.to_slug }.merge(date_to_param(@date))
    link_url = room_calendars_path(url_opts)

    fragment = node(link_to_free_booking(@room, @date, 30.minutes.to_i))

    assert_select fragment, "a.btn-primary[href='#{link_url}']", 'Réserver'
  end

  test '.link_to_free_booking with credits < 30.minutes' do
    fragment = node(link_to_free_booking(@room, @date, 29.minutes.to_i))

    assert_select fragment,
                  "a.btn-danger[href='mailto:#{RoomsHelper::BILLING_EMAIL}']",
                  'Acheter des crédits'
  end

  test '.link_to_paid_book with credits >= 30.minutes' do
    url_opts = { room_slug: @room.to_slug }.merge(date_to_param(@date))
    link_url = room_calendars_path(url_opts)

    fragment = node(link_to_paid_booking(@room, @date, 30.minutes.to_i))
    assert_select fragment,
                  "a.btn-warning[href='#{link_url}']",
                  'Réserver avec des crédits payant'
  end

  test '.link_to_paid_book with credits < 30.minutes' do
    fragment = node(link_to_paid_booking(@room, @date, 29.minutes.to_i))
    assert_select fragment,
                  "a.btn-danger[href='mailto:#{RoomsHelper::BILLING_EMAIL}']",
                  'Provisionner des crédits'
  end

  protected

  def node(raw_html)
    Nokogiri::HTML::DocumentFragment.parse(raw_html)
  end
end
