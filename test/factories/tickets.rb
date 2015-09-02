# == Schema Information
#
# Table name: tickets
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  checked_in_at   :datetime
#  order_id        :integer
#  student_number  :string
#  comment         :text
#  barcode         :string
#  barcode_data    :string
#  created_at      :datetime
#  updated_at      :datetime
#  access_level_id :integer
#  status          :string           default("initial")
#

FactoryGirl.define do
  factory :ticket do
    access_level
    order
    event

    status 'active'

    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
