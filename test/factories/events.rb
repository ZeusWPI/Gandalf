FactoryGirl.define do
  factory :event do
    club

    name { Faker::Name.name }
    description { Faker::Lorem.sentence }

    location { Faker::Address.city }
    contact_email { Faker::Internet.email }

    start_date { Faker::Time.forward(2) }
    end_date { Faker::Time.between(2.days.from_now + 1.minute, 3.days.from_now) }

    trait :has_iban_number do
      bank_number "BE68539007547034"
    end

    factory :event_with_iban, traits: [:has_iban_number]
  end
end
