# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  username            :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  cas_givenname       :string(255)
#  cas_surname         :string(255)
#  cas_ugentStudentID  :string(255)
#  cas_mail            :string(255)
#  cas_uid             :string(255)
#  admin               :boolean
#

FactoryGirl.define do
  factory :user do
    username { Faker::Name.name }

    trait :with_number do
      cas_ugentStudentID { Faker::Number.number(8).to_s }
    end

    factory :admin do
      admin true

      # Don't care for admin clubs
      after(:build) do |admin|
        admin.class.skip_callback(:create, :after, :fetch_club)
        admin.class.skip_callback(:create, :after, :fetch_enrolled_clubs)
      end
    end

    factory :numbered_user, traits: [:with_number]
  end

end
