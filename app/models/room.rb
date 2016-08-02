#
# Style: not raising NotImplemented error because it's for not yet implemented,
#        not abstact
class Room < ApplicationRecord
  # Booking properties
  AbstractError = 'AsbtractMethod, sub class only'

  def name
    raise AbstractError
  end

  def seats
    raise AbstractError
  end

  def free_time_per_week
    raise AbstractError
  end

  def cost_per_half_hour
    raise AbstractError
  end

end
