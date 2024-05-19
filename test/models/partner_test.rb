# frozen_string_literal: true

require 'test_helper'

class PartnerTest < ActiveSupport::TestCase
  verify_fixtures Partner
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: partners
#
#  id                     :bigint           not null, primary key
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
#  sign_in_count          :bigint           default(0), not null
#  created_at             :datetime
#  updated_at             :datetime
#  access_level_id        :bigint
#  event_id               :bigint
#
# Indexes
#
#  idx_16916_fk_rails_188986c214                     (event_id)
#  idx_16916_index_partners_on_access_level_id       (access_level_id)
#  idx_16916_index_partners_on_authentication_token  (authentication_token)
#  idx_16916_index_partners_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (access_level_id => access_levels.id) ON DELETE => restrict ON UPDATE => restrict
#  fk_rails_...  (event_id => events.id) ON DELETE => cascade ON UPDATE => restrict
#
