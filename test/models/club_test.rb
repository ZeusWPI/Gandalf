# frozen_string_literal: true

# == Schema Information
#
# Table name: clubs
#
#  id            :integer          not null, primary key
#  display_name  :string
#  full_name     :string
#  internal_name :string
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_clubs_on_internal_name  (internal_name) UNIQUE
#

require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  verify_fixtures Club

  # test "the truth" do
  #   assert true
  # end
end
