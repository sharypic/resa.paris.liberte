# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def create_rooms
  Shed.create!

  4.times do
    [Square, BigLodge, SmallLodge].each do |room_class|
      room_class.create!
    end
  end
end

def create_residents
  Resident.create!(email: 'fourcade.m@gmail.com',
                   password: ENV['DEFAULT_PWD'])
end

create_rooms
create_residents
