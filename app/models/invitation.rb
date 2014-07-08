
class Invitation < ActiveRecord::Base

  belongs_to :invitee
  belongs_to :inviter
  belongs_to :access_level

end
