# frozen_string_literal: true

# == Schema Information
#
# Table name: promos
#
#  id           :integer          not null, primary key
#  code         :string
#  limit        :integer
#  sold_tickets :integer          default(0)
#  created_at   :datetime
#  updated_at   :datetime
#  event_id     :integer
#
# Indexes
#
#  index_promos_on_event_id  (event_id)
#

require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
