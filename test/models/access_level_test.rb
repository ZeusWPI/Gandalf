# frozen_string_literal: true

require 'test_helper'

class AccessLevelTest < ActiveSupport::TestCase
  verify_fixtures AccessLevel

  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: access_levels
#
#  id          :bigint           not null, primary key
#  capacity    :bigint
#  has_comment :boolean
#  hidden      :boolean
#  name        :string(255)
#  permit      :string(255)      default("everyone")
#  price       :bigint
#  created_at  :datetime
#  updated_at  :datetime
#  event_id    :bigint
#
# Indexes
#
#  idx_16847_index_access_levels_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id) ON DELETE => cascade ON UPDATE => restrict
#
