module CalendarsHelper
  def iterate_day(from, to, step)
    while from <= to
      yield(from)
      from += step
    end
  end
end
