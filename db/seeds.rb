# entry point called below
def run
  ActiveRecord::Base.transaction do
    create_teams
    create_residents
    create_rooms
    create_reservations
  end
end

# Model creators helpers
def create_teams
  Team.create!(name: 'staff')
end

def create_rooms
  Shed.create!

  4.times do
    [Square, BigLodge, SmallLodge].each(&:create!)
  end
end

def create_residents
  Resident.create!(email: 'fourcade.m@gmail.com',
                   password: ENV['DEFAULT_PWD'],
                   team: Team.first)
end

def create_reservations
  today = Date.today.to_datetime

  half_hour_resa = Reservation.create!(name: '30 minutes resa',
                                       starts_at: today + 8.hours,
                                       ends_at: today + 8.hours + 30.minutes,
                                       room: SmallLodge.first,
                                       resident: Resident.first)

  two_hours_resa = Reservation.create!(name: '2 hours reservation',
                                       starts_at: today + 10.hours,
                                       ends_at: today + 10.hours,
                                       room: SmallLodge.first,
                                       resident: Resident.first)
end

run
