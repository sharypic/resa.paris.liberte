# Serialize / Deserialize dates
module DatetimeHelper
  def date_to_param(date)
    {
      year:    date.strftime('%Y'),
      month:   date.strftime('%m'),
      day:     date.strftime('%d')
    }
  end

  def datetime_to_param(datetime)
    {
      year:    datetime.strftime('%Y'),
      month:   datetime.strftime('%m'),
      day:     datetime.strftime('%d'),
      hour:    datetime.strftime('%H'),
      minute:  datetime.strftime('%M')
    }
  end

  def date_from_param(param)
    Time.zone.local(param[:year],
                    param[:month],
                    param[:day])
  end

  def datetime_from_param(param)
    Time.zone.local(param[:year],
                    param[:month],
                    param[:day],
                    param[:hour],
                    param[:minute])
  end

  def day_off?(date)
    date.sunday? || date.saturday?
  end

  def self.seconds_to_half_hour(amount_in_seconds)
    amount_in_seconds / 30.minutes.to_i
  end

  def self.half_hour_to_seconds(amount_in_half_hour)
    amount_in_half_hour * 30.minutes.to_i
  end
end
