# Help parse date from URI
# Constraint dates to be between monday and friday
# * not possible to book reservation on sunday/startuday
module DateParser
  include DatetimeHelper

  class MalformattedDateError < ArgumentError; end
  class DayOffError < RuntimeError; end

  def date_or_default(params, prefix = '')
    if parse_date?(params, prefix)
      date = date_from_param(params, prefix)
      raise DayOffError, 'how dare you' if day_off?(date)
      return date
    else
      default_date
    end
  rescue ArgumentError => e
    raise MalformattedDateError, e.message
  end

  def default_date
    date = Time.zone.today
    return date unless day_off?(date)
    date.beginning_of_the_week
  end

  def parse_date?(params, prefix = '')
    [:"#{prefix}year",
     :"#{prefix}month",
     :"#{prefix}day"].all? { |key| params.key?(key) }
  end
end
