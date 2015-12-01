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

    factory :free_order do
      paid 0
      price 0
    end

    factory :paid_order do
      price 10

      factory :unpaid_order do
        paid 0
      end

      factory :partially_paid_order do
        paid 5
      end

      factory :fully_paid_order do
        paid 10
      end
    end

    # Related tickets
    transient do
      ticket_count 3
    end

    after(:build) do |order, evaluator|
      order.tickets << build_list(:ticket, evaluator.ticket_count, order: order)
    end
  end
end
