# frozen_string_literal: true
require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  verify_fixtures Club

  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: clubs
#
#  id            :integer          not null, primary key
#  display_name  :string(255)
#  full_name     :string(255)
#  internal_name :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_clubs_on_internal_name  (internal_name) UNIQUE
#
