class CreateCreditLines < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_lines do |t|
      t.references :team, foreign_key: true
      t.string     :room_type
      t.integer    :amount

      t.timestamps
    end
  end
end
