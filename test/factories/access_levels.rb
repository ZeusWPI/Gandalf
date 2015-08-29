FactoryGirl.define do
  factory :access_level do
    event

    name { Faker::Name.name }
    price 0

    trait :paid do
      association :event, factory: :event_with_iban
      price { Faker::Number.number(2) }
    end

    factory :paid_access_level, traits: [:paid]
  end
end
