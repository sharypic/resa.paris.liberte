# entry point called below
def run
  ActiveRecord::Base.transaction do
    create_teams
    create_residents
    create_rooms
    # create_reservations(Time.zone.today)
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
                   team: Team.first,
                   firstname: 'Martin',
                   lastname: 'Fourcade',
                   admin: true,
                   confirmed_at: Time.now.utc)
end

# rubocop:disable Metrics/AbcSize
def create_reservations(today)
  opts = { room: SmallLodge.first, resident: Resident.first }
  Reservation.create!(opts.merge(starts_at: today + 8.hours,
                                 ends_at: today + 8.hours + 30.minutes))
  Reservation.create!(opts.merge(starts_at: today + 10.hours,
                                 ends_at: today + 10.hours))
end
# rubocop:enable Metrics/AbcSize

run
Resident.create!(
  email: 'admin@example.com', 
  password: 'password', 
  password_confirmation: 'password'
  confirmed_at: Time.now.utc
)
