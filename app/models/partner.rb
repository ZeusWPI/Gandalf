# frozen_string_literal: true

# == Schema Information
#
# Table name: partners
#
#  id                     :integer          not null, primary key
#  authentication_token   :string(255)
#  confirmed              :boolean
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  name                   :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime
#  updated_at             :datetime
#  access_level_id        :integer
#  event_id               :integer
#
# Indexes
#
#  index_partners_on_access_level_id       (access_level_id)
#  index_partners_on_authentication_token  (authentication_token)
#  index_partners_on_name_and_event_id     (name,event_id) UNIQUE
#  index_partners_on_reset_password_token  (reset_password_token) UNIQUE
#

class Partner < ApplicationRecord
  acts_as_token_authenticatable
  has_paper_trail

  devise :timeoutable, :trackable

  belongs_to :event
  belongs_to :access_level

  after_save :deliver, if: :email_changed?

  validates :name, presence: true
  # [Tom] I commented this out to fix a current restraint:
  # We sometimes only have the emailadress of a partner, even if
  # this partner is allowed to invite 5 persons. This way, we can
  # add as many partners with a different name and the same address.
  # This will be fixed in the advanced view though.
  # [Tom 8 years later] lol advanced view
  # validates :email, uniqueness: { scope: :event_id }
  validates :email, email: true

  default_scope { order "name ASC" }

  def deliver
    PartnerMailer.invitation(self).deliver_later
  end
end
