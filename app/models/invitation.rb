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


class Invitation < ActiveRecord::Base

  belongs_to :invitee
  belongs_to :inviter
  belongs_to :access_level

end
