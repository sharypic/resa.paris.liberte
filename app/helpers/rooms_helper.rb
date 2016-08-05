# UI helpers for rooms
module RoomsHelper
  BILLING_EMAIL = 'people@paris.liberte'.freeze

  def block_free_seconds_per_week(team, room, date)
    max_free = room.free_seconds_per_week
    free_seconds_available = team.weekly_free_seconds_available(room, date)
    free_progress = 100 - (100 * free_seconds_available / max_free)

    content_tag :div do
      concat progress_bar(free_progress)
      concat label_half_hours_available(free_seconds_available, :free)
      concat link_to_free_booking(room, date, free_seconds_available)
    end
  end

  def block_paid_seconds(team, room, date)
    paid_seconds_available = team.paid_seconds_available(room)

    content_tag :div do
      concat progress_bar(paid_seconds_available > 0 ? 100 : 0)
      concat label_half_hours_available(paid_seconds_available, :paid)
      concat link_to_paid_booking(room, date, paid_seconds_available)
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
    label_for_type = type == :free ? 'gratuite' : 'payante'
    suffix = type == :free ? ' cette semaine' : ''

    content_tag :p,
                format('%d demi-heure %s restante%s',
                       half_hours, label_for_type, suffix),
                class: 'notice-progress-consumption'
  end

  def room_calendars_date_path(room, date)
    url_opts = { room_slug: room.to_slug }.merge(date_to_param(date))

    room_calendars_path(url_opts)
  end

  def link_to_free_booking(room, date, free_seconds_available)
    if DatetimeHelper.seconds_to_half_hour(free_seconds_available) > 0
      link_to('Réserver',
              room_calendars_date_path(room, date),
              class: 'btn btn-primary')
    else
      mail_to(BILLING_EMAIL, 'Acheter des crédits', class: 'btn btn-danger')
    end
  end

  def link_to_paid_booking(room, date, paid_seconds_available)
    if DatetimeHelper.seconds_to_half_hour(paid_seconds_available) > 0
      link_to('Réserver avec des crédits payant',
              room_calendars_date_path(room, date),
              class: 'btn btn-warning')
    else
      mail_to(BILLING_EMAIL,
              'Provisionner des crédits',
              class: 'btn btn-danger')
    end
  end
end
