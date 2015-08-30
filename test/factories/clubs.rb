# == Schema Information
#
# Table name: clubs
#
#  id            :integer          not null, primary key
#  full_name     :string(255)
#  internal_name :string(255)
#  display_name  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

FactoryGirl.define do
  factory :club do
    full_name { Faker::Name.name }
    internal_name { full_name.gsub(/\s+/, "").downcase }
    display_name { full_name }

    # Specific clubs for the user model api fetch tests
    factory :club_fk do
      full_name "FaculteitenKonvent Gent"
      internal_name "fkcentraal"
    end

    factory :club_zeus do
      full_name "Zeus WPI"
      internal_name "zeus"
    end
  end
end
