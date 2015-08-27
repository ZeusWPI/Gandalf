FactoryGirl.define do
  factory :user do
    username Faker::Name.name

    trait :with_number do
      cas_ugentStudentID Faker::Number.number(8).to_s
    end

    factory :numbered_user, traits: [:with_number]
  end

end
