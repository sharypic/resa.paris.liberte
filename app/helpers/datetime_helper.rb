# Serialize / Deserialize dates
module DatetimeHelper
  def date_to_param(date, prefix = '')
    {
      :"#{prefix}year"  => date.strftime('%Y'),
      :"#{prefix}month" => date.strftime('%m'),
      :"#{prefix}day"   => date.strftime('%d')
    }
  end

  def datetime_to_param(datetime, prefix = '')
    {
      :"#{prefix}year" =>   datetime.strftime('%Y'),
      :"#{prefix}month" =>  datetime.strftime('%m'),
      :"#{prefix}day" =>    datetime.strftime('%d'),
      :"#{prefix}hour" =>   datetime.strftime('%H'),
      :"#{prefix}minute" => datetime.strftime('%M')
    }
  end

  def date_from_param(param, prefix = '')
    Time.zone.local(param[:"#{prefix}year"],
                    param[:"#{prefix}month"],
                    param[:"#{prefix}day"])
  end

  def datetime_from_param(param, prefix = '')
    Time.zone.local(param[:"#{prefix}year"],
                    param[:"#{prefix}month"],
                    param[:"#{prefix}day"],
                    param[:"#{prefix}hour"],
                    param[:"#{prefix}minute"])
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
