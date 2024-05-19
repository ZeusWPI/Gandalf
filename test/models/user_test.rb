# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  verify_fixtures User
end

# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  admin               :boolean
#  cas_givenname       :string(255)
#  cas_mail            :string(255)
#  cas_surname         :string(255)
#  cas_ugentstudentid  :string(255)
#  cas_uid             :string(255)
#  current_sign_in_at  :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_at     :datetime
#  last_sign_in_ip     :string(255)
#  remember_created_at :datetime
#  sign_in_count       :bigint           default(0), not null
#  username            :string(255)      not null
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  idx_16946_index_users_on_username  (username) UNIQUE
#
