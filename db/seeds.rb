# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
require 'webmock'
WebMock.allow_net_connect!
url = 'http://student.ugent.be/hydra/api/2.0/associations.json'
hash = JSON(HTTParty.get(url).body)
WebMock.disable_net_connect!

hash.each do |club|
  next unless 1 == 0
  next unless club['parentAssociation'] == 'FK'

  club = Club.new do |c|
    c.internal_name = club['internalName'].downcase
    c.display_name = club['displayName']
    c.full_name = club['fullName'] unless club['fullName'].blank?
  end
  club.save
end

# Zeus peoples
club = Club.new do |c|
  c.internal_name = 'zeus'
  c.display_name = 'Zeus WPI'
  c.full_name = nil
end
club.save

ugent = Club.new do |c|
  c.internal_name = 'ugent'
  c.display_name = 'Universiteit Gent'
  c.full_name = nil
end
ugent.save

# Create an event
event = Event.new do |e|
  e.name = "Blarghbal"
  e.description = "Blargh der blarghs"
  e.start_date = Date.today
  e.end_date = Date.tomorrow
  e.location = "Blarghkasteel"
  e.contact_email "blargh@blargher.bla"
  e.club = ugent
end
event.save!
