# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  invitee_id      :integer
#  inviter_id      :integer
#  comment         :text
#  paid            :integer
#  price           :integer
#  selected        :boolean          default(FALSE)
#  accepted        :boolean          default(FALSE)
#  access_level_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
