# == Schema Information
#
# Table name: tickets
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  gsm             :string(255)
#  checked_in_at   :datetime
#  event_id        :integer
#  order_id        :integer
#  student_number  :string(255)
#  comment         :text
#  barcode         :string(255)
#  barcode_data    :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  access_level_id :integer
#

require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
