class AddAdminToResidents < ActiveRecord::Migration[5.0]
  def change
    add_column :residents, :admin, :boolean
  end
end
