class CreateTimeAccountLines < ActiveRecord::Migration[5.0]
  def change
    create_table :time_account_lines do |t|
      t.references :team,         foreign_key: true
      t.references :reservation,  foreign_key: true
      t.string     :room_type
      t.string     :type
      t.integer    :amount

      t.timestamps
    end
  end
end
