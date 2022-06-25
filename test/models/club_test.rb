# frozen_string_literal: true

# == Schema Information
#
# Table name: clubs
#
#  id            :integer          not null, primary key
#  full_name     :string
#  internal_name :string
#  display_name  :string
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  verify_fixtures Club

  # test "the truth" do
  #   assert true
  # end
end
