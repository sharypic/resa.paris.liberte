class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.string :name

      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
    add_reference :reservations, :room, foreign_key: true, index: true
    add_reference :reservations, :resident, foreign_key: true, index: true

    add_index :reservations, [:room_id, :starts_at, :ends_at], unique: true
  end
end
