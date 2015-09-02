# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  status       :string           default("initial")
#  name         :string
#  email        :string
#  gsm          :string
#  ticket_id    :integer
#  event_id     :integer
#  paid         :integer
#  price        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  payment_code :string
#

FactoryGirl.define do
  factory :order do
    event

    status 'active'

    name { Faker::Name.name }
    email { Faker::Internet.email }

    paid 0
    price { Faker::Number.number(2) }

    # Related tickets
    transient do
      ticket_count 3
    end

    after(:build) do |order, evaluator|
      order.tickets << build_list(:ticket, evaluator.ticket_count, order: order)
    end
  end
end
