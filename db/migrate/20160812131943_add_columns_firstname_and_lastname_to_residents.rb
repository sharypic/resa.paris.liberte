class AddColumnsFirstnameAndLastnameToResidents < ActiveRecord::Migration[5.0]
  def change
    add_column :residents, :firstname, :string
    add_column :residents, :lastname, :string
  end
end
