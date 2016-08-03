module CalendarsHelper
  def iterate_day(from, to, step)
    while from <= to
      next_step = from + step
      yield(from, next_step)
      from = next_step
    end
  end
end
