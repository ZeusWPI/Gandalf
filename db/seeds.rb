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
data = JSON(HTTParty.get(url).body)["associations"]
WebMock.disable_net_connect!

# Zeus peoples
puts "Add Zeus WPI <3"
club = Club.new do |c|
  c.internal_name = 'zeus'
  c.display_name = 'Zeus WPI'
  c.full_name = 'Zeus WPI'
end
club.save

puts "Seed clubs from DSA api"
puts "---"

data.each do |association|
  next unless association['path'].include?('fk')

  puts "Add " + association['name']

  club = Club.new do |c|
    c.internal_name = association['abbreviation'].downcase
    c.display_name = association['name']
    c.full_name = association['name'] unless association['name'].blank?
  end
  club.save
end

