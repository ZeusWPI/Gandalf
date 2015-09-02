# == Schema Information
#
# Table name: events
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  start_date              :datetime
#  end_date                :datetime
#  location                :string(255)
#  website                 :string(255)
#  description             :text
#  created_at              :datetime
#  updated_at              :datetime
#  registration_open_date  :datetime
#  registration_close_date :datetime
#  bank_number             :string(255)
#  show_ticket_count       :boolean          default(TRUE)
#  contact_email           :string(255)
#  export_file_name        :string(255)
#  export_content_type     :string(255)
#  export_file_size        :integer
#  export_updated_at       :datetime
#  show_statistics         :boolean
#  export_status           :string(255)
#  club_id                 :integer
#  registration_open       :boolean          default(TRUE)
#

FactoryGirl.define do
  factory :event do
    club

    name { Faker::Name.name }
    description { Faker::Lorem.sentence }

    location { Faker::Address.city }
    contact_email { Faker::Internet.email }

    start_date { Faker::Time.forward(2) }
    end_date { Faker::Time.between(start_date + 1.minute, 3.days.from_now) }

    # Traits
    trait :has_iban_number do
      bank_number "BE68539007547034"
    end

    factory :event_with_iban, traits: [:has_iban_number]

    # Related attributes
    transient do
      access_level_count 5
    end

    after(:create) do |event, evaluator|
      create_list(:access_level, evaluator.access_level_count, event: event)
    end
  end
end
