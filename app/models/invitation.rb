# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  send            :boolean
#  access_level_id :integer
#  inviter_id      :integer
#  invitee_id      :integer
#  price           :integer
#  paid            :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Invitation < ActiveRecord::Base
  belongs_to :access_level
  belongs_to :inviter, class_name: "Partner"
  belongs_to :invitee, class_name: "Partner"
end
