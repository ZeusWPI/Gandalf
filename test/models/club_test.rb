# == Schema Information
#
# Table name: clubs
#
#  id            :integer          not null, primary key
#  full_name     :string(255)
#  internal_name :string(255)
#  display_name  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class ClubTest < ActiveSupport::TestCase
end
