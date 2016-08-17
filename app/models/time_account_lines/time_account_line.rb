# == Schema Information
#
# Table name: time_account_lines
#
#  id             :integer          not null, primary key
#  team_id        :integer
#  reservation_id :integer
#  room_type      :string
#  type           :string
#  amount         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# Allow team to pay for more time in room
class TimeAccountLine < ApplicationRecord
  belongs_to :team

  def half_hours_used
    if amount > 0
      DatetimeHelper.seconds_to_half_hour(amount)
    else
      -DatetimeHelper.seconds_to_half_hour(-amount)
    end
  end
end
