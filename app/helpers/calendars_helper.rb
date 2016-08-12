# Simple iterator to render a calendar
# from a datetime
# to a datetime
# by step
module CalendarsHelper
  def iterate_day(date, step)
    from = date + 8.hours
    to = date + 20.hours

    while from <= to
      next_step = from + step
      yield(from, next_step)
      from = next_step
    end
  end

  def classname_for_room(slug)
    "test-calendar-#{slug}"
  end

  def classname_for_date(date)
    "test-calendar-#{date.strftime('%d-%m-%Y')}"
  end
end
