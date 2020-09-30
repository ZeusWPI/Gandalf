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
url = 'https://dsa.ugent.be/api/verenigingen'
hash = JSON(HTTParty.get(url).body)["associations"]
WebMock.disable_net_connect!

puts hash

hash.each do |club|
  puts club
  next unless club['path'].include?('fk')
  puts "From fk!"

  club = Club.new do |c|
    c.internal_name = club['abbreviation'].downcase
    c.display_name = club['name']
    c.full_name = club['name'] unless club['name'].blank?
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
