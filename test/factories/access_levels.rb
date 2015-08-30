# == Schema Information
#
# Table name: access_levels
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  event_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  capacity    :integer
#  price       :integer
#  public      :boolean          default(TRUE)
#  has_comment :boolean
#  hidden      :boolean
#  member_only :boolean
#

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
