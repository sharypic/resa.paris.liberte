# UI helpers for rooms
module RoomsHelper
  BILLING_EMAIL = 'people@paris.liberte'.freeze

  def block_free_seconds_per_week(resident, room, date)
    max = room.free_seconds_per_week
    seconds_available = resident.team.weekly_free_seconds_available(room, date)
    progress = 100 - (100 * seconds_available / max)

    content_tag :div do
      concat progress_free_seconds_per_week(progress)
      concat label_half_hours_available(seconds_available)
      concat link_to_book(room, date, seconds_available)
    end
  end

  def progress_free_seconds_per_week(progress)
    content_tag :div, class: 'progress' do
      concat content_tag :div, '', class: 'progress-bar', role: 'progressbar',
                                   :'aria-valuenow' => progress,
                                   :'aria-valuemin' => 0,
                                   :'aria-valuemax' => 100,
                                   style: "width: #{progress}%;"
    end
  end

  def label_half_hours_available(seconds_available)
    half_hours = DatetimeHelper.seconds_to_half_hour(seconds_available)

    content_tag :p,
                format('%d demi-heure restante cette semaine',
                       half_hours),
                class: 'notice-progress-consumption'
  end

  def link_to_book(room, date, seconds_available)
    url_opts = { room_slug: room.to_slug }.merge(date_to_param(date))

    if DatetimeHelper.seconds_to_half_hour(seconds_available) > 0
      link_to('Réserver',
              room_calendars_path(url_opts),
              class: 'btn btn-primary')
    else
      mail_to(BILLING_EMAIL,
              'Acheter des crédits',
              class: 'btn btn-danger')
    end
  end
end
