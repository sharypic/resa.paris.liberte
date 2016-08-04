require 'test_helper'

class RoomsHelperTest < ActionView::TestCase
  include DatetimeHelper

  setup do
    @room = Shed.new
    @date = Time.zone.today
  end

  # test 'block_free_seconds_per_week' do
  # end

  test 'progress_free_seconds_per_week' do
    fragment = node(progress_free_seconds_per_week(10))

    assert_select fragment, 'div.progress' do
      assert_select "div.progress-bar[style='width: 10%;']"
    end
  end

  test 'label_half_hours_available' do
    fragment = node(label_half_hours_available(30.minutes.to_i))

    assert_select fragment,
                  'p.notice-progress-consumption',
                  '1 demi-heure restante cette semaine'
  end

  test 'link_to_book with credits > 30.minutes' do
    url_opts = { room_slug: @room.to_slug }.merge(date_to_param(@date))
    link_url = room_calendars_path(url_opts)

    fragment = node(link_to_book(@room, @date, 30.minutes.to_i))

    assert_select fragment, "a[href='#{link_url}']"
  end

  test 'link_to_book with credits < 30.minutes' do
    fragment = node(link_to_book(@room, @date, 29.minutes.to_i))

    assert_select fragment, "a[href='mailto:#{RoomsHelper::BILLING_EMAIL}']"
  end

  protected

  def node(raw_html)
    Nokogiri::HTML::DocumentFragment.parse(raw_html)
  end
end
