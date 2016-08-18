class AddNameToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :name, :string
    Room.all.each do |room|
      room.name = "#{room.denomination} - #{room.id}"
      room.save!
    end
  end
end
