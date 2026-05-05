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
#  id                      :integer          not null, primary key
#  bank_number             :string
#  contact_email           :string
#  description             :text
#  end_date                :datetime
#  export_content_type     :string
#  export_file_name        :string
#  export_file_size        :integer
#  export_status           :string
#  export_updated_at       :datetime
#  location                :string
#  name                    :string
#  registration_close_date :datetime
#  registration_open       :boolean          default(TRUE)
#  registration_open_date  :datetime
#  require_physical_ticket :boolean          default(FALSE), not null
#  show_statistics         :boolean
#  show_ticket_count       :boolean          default(TRUE)
#  signature               :text
#  start_date              :datetime
#  website                 :string
#  created_at              :datetime
#  updated_at              :datetime
#  club_id                 :integer
#
# Indexes
#
#  fk_rails_fc45ac705d  (club_id)
#
# Foreign Keys
#
#  fk_rails_...  (club_id => clubs.id) ON DELETE => cascade
#
