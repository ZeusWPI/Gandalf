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
#  public      :boolean          default("t")
#  has_comment :boolean
#  hidden      :boolean
#  member_only :boolean
#

require 'test_helper'

class AccessLevelTest < ActiveSupport::TestCase
  verify_fixtures AccessLevel

  # test "the truth" do
  #   assert true
  # end
end
