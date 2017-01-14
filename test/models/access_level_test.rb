# == Schema Information
#
# Table name: access_levels
#
#  id          :integer          not null, primary key
#  name        :string
#  event_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  capacity    :integer
#  price       :integer
#  has_comment :boolean
#  hidden      :boolean
#  permit      :string           default("everyone")
#

require 'test_helper'

class AccessLevelTest < ActiveSupport::TestCase
  verify_fixtures AccessLevel

  # test "the truth" do
  #   assert true
  # end
end
