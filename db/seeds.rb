# entry point called below
def run
  ActiveRecord::Base.transaction do
    create_teams
    create_residents
    create_rooms
  end
end

# Model creators helpers
def create_teams
  Team.create!(name: 'staff')
end

def create_rooms
  Shed.create!(name: 'Atelier B (2e)')
  
  [
    'Carré A (3e)', 
    'Carré B (3e)',
    'Carré C (4e)',
    'Carré D (4e)'].each do |square_name|
    Square.create!(name: square_name)
  end
  
  ['Loge A (2e)', 
   'Loge B (2e)', 
   'Loge C (3e)', 
   'Loge F (4e)'].each do |big_lodge_name|
    BigLodge.create!(name: big_lodge_name)
  end

  ['Loge D (3e)', 
   'Loge E (4e)', 
   'Loge G (4e)', 
   'Loge H (4e)'].each do |small_lodge_name|
    SmallLodge.create!(name: small_lodge_name)
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

run
