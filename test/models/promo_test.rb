# == Schema Information
#
# Table name: promos
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  code       :string(255)
#  limit      :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
