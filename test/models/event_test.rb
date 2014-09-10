# == Schema Information
#
# Table name: events
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  start_date              :datetime
#  end_date                :datetime
#  location                :string(255)
#  website                 :string(255)
#  description             :text
#  created_at              :datetime
#  updated_at              :datetime
#  registration_open_date  :datetime
#  registration_close_date :datetime
#  bank_number             :string(255)
#  show_ticket_count       :boolean          default(TRUE)
#  contact_email           :string(255)
#  export_file_name        :string(255)
#  export_content_type     :string(255)
#  export_file_size        :integer
#  export_updated_at       :datetime
#  show_statistics         :boolean
#  export_status           :string(255)
#  club_id                 :integer
#  registration_open       :boolean          default(TRUE)
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  verify_fixtures Event

  # test "the truth" do
  #   assert true
  # end
  #

  test "enable_toggling_of_registration_status" do
    e = Event.new

    assert e.registration_open
    e.save

    e.toggle_registration_open
    e.save

    assert_not e.registration_open

    e.toggle_registration_open
    e.save

    assert e.registration_open
  end
end
