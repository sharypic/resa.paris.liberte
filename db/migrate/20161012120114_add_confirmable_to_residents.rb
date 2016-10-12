class AddConfirmableToResidents < ActiveRecord::Migration[5.0]
  def change
    add_column :residents, :confirmation_token, :string
    add_column :residents, :confirmed_at, :datetime
    add_column :residents, :confirmation_sent_at, :datetime
    add_column :residents, :unconfirmed_email, :string
  end
end
