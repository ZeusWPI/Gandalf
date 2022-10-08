# frozen_string_literal: true

# == Schema Information
#
# Table name: access_levels
#
#  id          :integer          not null, primary key
#  capacity    :integer
#  has_comment :boolean
#  hidden      :boolean
#  name        :string(255)
#  permit      :string(255)      default("everyone")
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#  event_id    :integer
#
# Indexes
#
#  index_access_levels_on_event_id  (event_id)
#

require 'test_helper'

class AccessLevelTest < ActiveSupport::TestCase
  verify_fixtures AccessLevel

  # test "the truth" do
  #   assert true
  # end
end
