# frozen_string_literal: true

# == Schema Information
#
# Table name: promos
#
#  id           :integer          not null, primary key
#  event_id     :integer
#  code         :string
#  limit        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  sold_tickets :integer          default(0)
#

require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
