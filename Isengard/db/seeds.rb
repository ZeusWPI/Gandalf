# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

url = 'https://raw2.github.com/ZeusWPI/hydra/master/iOS/Resources/Associations.json'
hash = JSON HTTParty.get(url)

hash.each do |club|
  next if club['internalName'] == club['parentAssociation'] or club['parentAssociation'] != 'FKCENTRAAL'

  club = Club.new do |c|
    c.internal_name = club['internalName']
    c.display_name = club['displayName']
    c.full_name = club['fullName'] unless club['fullName'].blank?
  end
  club.save
end
