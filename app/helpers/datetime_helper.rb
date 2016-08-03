# Serialize / Deserialize dates
module DatetimeHelper
  def date_to_param(datetime)
    {
      year:    datetime.strftime('%Y'),
      month:   datetime.strftime('%m'),
      day:     datetime.strftime('%d')
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

  def datetime_from_param(param)
    Time.zone.local(param[:year],
                    param[:month],
                    param[:day],
                    param[:hour],
                    param[:minute])
  end
end
