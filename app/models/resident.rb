# == Schema Information
#
# Table name: residents
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  team_id                :integer
#  firstname              :string
#  lastname               :string
#  admin                  :boolean
#

# Resident is able to book rooms
class Resident < ApplicationRecord
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  belongs_to :team
  has_many :reservations

  def fullname
    "#{firstname} #{lastname}"
  end

  def usage_of(room_type, from_date, to_date)
    room_type_ids = room_type.select(:id).all.map(&:id)

    reservations.in_range((from_date..to_date)).all.sum do |reservation|
      if room_type_ids.include?(reservation.room_id)
        reservation.cached_duration_in_seconds
      else
        0
      end
    end
  end
end
