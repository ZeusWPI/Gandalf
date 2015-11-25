# == Schema Information
#
# Table name: partners
#
#  id                     :integer          not null, primary key
#  name                   :string
#  email                  :string
#  authentication_token   :string
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  event_id               :integer
#  access_level_id        :integer
#  confirmed              :boolean
#

class Partner < ActiveRecord::Base
  acts_as_token_authenticatable
  has_paper_trail

  devise :timeoutable, :trackable

  belongs_to :event
  belongs_to :access_level

  after_save :deliver, if: :email_changed?

  validates :name, uniqueness: { scope: :event_id }
  # [Tom] I commented this out to fix a current restraint:
  # We sometimes only have the emailadress of a partner, even if
  # this partner is allowed to invite 5 persons. This way, we can
  # add as many partners with a different name and the same address.
  # This will be fixed in the advanced view though.
  # validates :email, uniqueness: { scope: :event_id }
  validates :email, email: true

  default_scope { order 'name ASC' }

  def deliver
    PartnerMailer.invitation(self).deliver
  end
end
