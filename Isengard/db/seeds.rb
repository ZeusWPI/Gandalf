# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

url = 'http://student.ugent.be/hydra/api/1.1/Associations.json'
hash = JSON HTTParty.get(url)

hash.each do |club|
  next unless club['parentAssociation'] == 'FKCENTRAAL'

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
