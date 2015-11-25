# == Schema Information
#
# Table name: events
#
#  id                      :integer          not null, primary key
#  name                    :string
#  start_date              :datetime
#  end_date                :datetime
#  location                :string
#  website                 :string
#  description             :text
#  created_at              :datetime
#  updated_at              :datetime
#  registration_open_date  :datetime
#  registration_close_date :datetime
#  bank_number             :string
#  show_ticket_count       :boolean          default(TRUE)
#  contact_email           :string
#  export_file_name        :string
#  export_content_type     :string
#  export_file_size        :integer
#  export_updated_at       :datetime
#  show_statistics         :boolean
#  export_status           :string
#  club_id                 :integer
#  registration_open       :boolean          default(TRUE)
#  signature               :text
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test 'enable_toggling_of_registration_status' do
    e = build(:event)

    assert e.registration_open
    assert e.save

    e.toggle_registration_open
    assert e.save

    assert_not e.registration_open

    e.toggle_registration_open
    assert e.save

    assert e.registration_open
  end
end
