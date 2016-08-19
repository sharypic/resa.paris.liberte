# UI helpers for rooms
module RoomsHelper
  BILLING_EMAIL = 'people@paris.liberte'.freeze

  def available_seconds_per_week(team, room, date)
    free_seconds_available = team.weekly_free_seconds_available(room, date)
    paid_seconds_available = team.paid_seconds_available(room)

    content_tag :div do
      concat block_free_seconds(room, date, free_seconds_available)
      concat link_to_paid_booking(room, date, paid_seconds_available)
      concat block_paid_seconds(paid_seconds_available)
    end
  end

  def block_free_seconds(room, date, free_seconds_available)
    max_free = room.free_seconds_per_week
    free_progress = 100 * free_seconds_available / max_free

    progress_bar(free_progress) +
      label_half_hours_available(free_seconds_available, :free) +
      link_to_free_booking(room, date, free_seconds_available)
  end

  def block_paid_seconds(paid_seconds_available)
    content_tag :div do
      concat label_half_hours_available(paid_seconds_available, :paid)
      concat link_to_pay_for_booking
    end
  end

  def progress_bar(progress)
    content_tag :div, class: 'progress' do
      concat content_tag :div, '', class: 'progress-bar', role: 'progressbar',
                                   :'aria-valuenow' => progress,
                                   :'aria-valuemin' => 0,
                                   :'aria-valuemax' => 100,
                                   style: "width: #{progress}%;"
    end
  end

  def label_half_hours_available(seconds_available, type)
    half_hours = DatetimeHelper.seconds_to_half_hour(seconds_available)

    content_tag :p,
                I18n.t("rooms.index.#{type}_half_hours_available",
                       count: half_hours),
                class: 'notice-progress-consumption'
  end

  def room_calendars_date_path(room, date)
    url_opts = { room_slug: room.to_slug }.merge(date_to_param(date))

    room_calendars_path(url_opts)
  end

  def link_to_free_booking(room,
                           date,
                           free_seconds_available)
    if DatetimeHelper.seconds_to_half_hour(free_seconds_available) > 0
      link_to(I18n.t('rooms.index.links.book.text'),
              room_calendars_date_path(room, date),
              class: 'btn btn-primary',
              title: I18n.t('rooms.index.links.book.title',
                            room_denomination: room.denomination))
    else
      button_tag(I18n.t('rooms.index.links.book.text'),
                 class: 'btn btn-primary disabled')
    end
  end

  def link_to_paid_booking(room, date, paid_seconds_available)
    if DatetimeHelper.seconds_to_half_hour(paid_seconds_available) > 0
      link_to(I18n.t('rooms.index.links.book_paid.text'),
              room_calendars_date_path(room, date),
              class: 'btn btn-warning m-l-1',
              title: I18n.t('rooms.index.links.book_paid.title'))
    end
  end

  def link_to_pay_for_booking
    mail_to(BILLING_EMAIL,
            I18n.t('rooms.index.links.pay_for_credits.text'),
            class: 'btn btn-danger',
            title: I18n.t('rooms.index.links.pay_for_credits.title'))
  end
end
