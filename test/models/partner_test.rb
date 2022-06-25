# frozen_string_literal: true

# == Schema Information
#
# Table name: partners
#
#  id                     :integer          not null, primary key
#  authentication_token   :string
#  confirmed              :boolean
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
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

require 'test_helper'

class PartnerTest < ActiveSupport::TestCase
  verify_fixtures Partner
  # test "the truth" do
  #   assert true
  # end
end
