class AddColumnCachedDurationInSecondsToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :cached_duration_in_seconds, :integer
  end
end
