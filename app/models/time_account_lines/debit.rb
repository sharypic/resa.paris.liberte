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

# Positive time account line (amount<0)
class Debit < TimeAccountLine
  belongs_to :reservation

  validates :amount, numericality: { less_than: 0 }
end
