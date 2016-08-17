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

# Positive time account line (amount>0)
class Credit < TimeAccountLine
  validates :amount, numericality: { greater_than: 0 }

  def resident
    NullResident.new
  end

  def room
    NullRoom.new
  end
end
