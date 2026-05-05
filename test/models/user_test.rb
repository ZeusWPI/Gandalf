# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  verify_fixtures User
end

# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  admin               :boolean
#  cas_givenname       :string
#  cas_mail            :string
#  cas_surname         :string
#  cas_ugentstudentid  :string
#  cas_uid             :string
#  current_sign_in_at  :datetime
#  current_sign_in_ip  :string
#  last_sign_in_at     :datetime
#  last_sign_in_ip     :string
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  username            :string           not null
#  zeus_uid            :string
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
