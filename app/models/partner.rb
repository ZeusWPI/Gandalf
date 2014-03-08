# == Schema Information
#
# Table name: partners
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  authentication_token   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  event_id               :integer
#

class Partner < ActiveRecord::Base
  acts_as_token_authenticatable
  has_paper_trail

  devise :timeoutable, :trackable

  belongs_to :event

  validates :name, uniqueness: true
  validates :email, uniqueness: true
end
