module NullObjects
  # For Reservation not using free credit
  # Maybe? Refactor a FreeTimeAccountLine ?
  class TimeAccountLine
    def amount
      0
    end
  end
end
