# frozen_string_literal: true

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  verify_fixtures Event

  test "enable_toggling_of_registration_status" do
    e = events(:codenight)

    assert(e.registration_open)
    e.save!

    e.toggle_registration_open
    e.save!

    assert_not(e.registration_open)

    e.toggle_registration_open
    e.save!

    assert(e.registration_open)
  end
end

# == Schema Information
#
# Table name: events
#
#  id                      :bigint           not null, primary key
#  bank_number             :string(255)
#  contact_email           :string(255)
#  description             :text
#  end_date                :datetime
#  export_content_type     :string(255)
#  export_file_name        :string(255)
#  export_file_size        :bigint
#  export_status           :string(255)
#  export_updated_at       :datetime
#  location                :string(255)
#  name                    :string(255)
#  registration_close_date :datetime
#  registration_open       :boolean          default(TRUE)
#  registration_open_date  :datetime
#  require_physical_ticket :boolean          default(FALSE), not null
#  show_statistics         :boolean
#  show_ticket_count       :boolean          default(TRUE)
#  signature               :text
#  start_date              :datetime
#  website                 :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  club_id                 :bigint
#
# Indexes
#
#  idx_16898_fk_rails_fc45ac705d  (club_id)
#
# Foreign Keys
#
#  fk_rails_...  (club_id => clubs.id) ON DELETE => cascade ON UPDATE => restrict
#
