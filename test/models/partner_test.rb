# frozen_string_literal: true

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

require 'test_helper'

class PartnerTest < ActiveSupport::TestCase
  verify_fixtures Partner
  # test "the truth" do
  #   assert true
  # end
end
