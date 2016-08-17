module NullObjects
  # For TimeAccountLine::Credit: no resident
  class Resident
    def fullname
      ''
    end
  end
end
