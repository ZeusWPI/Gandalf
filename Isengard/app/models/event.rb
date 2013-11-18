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
#  organisation            :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  club                    :string(255)
#  registration_open_date  :datetime
#  registration_close_date :datetime
#  bank_number             :string(255)
#  show_ticket_count       :boolean          default(TRUE)
#  contact_email           :string(255)
#  export_file_name        :string(255)
#  export_content_type     :string(255)
#  export_file_size        :integer
#  export_updated_at       :datetime
#

class Event < ActiveRecord::Base

  has_many :access_levels, dependent: :destroy
  has_many :zones, dependent: :destroy
  has_many :registrations, dependent: :destroy

  has_many :roles, dependent: :destroy
  has_many :people, through: :roles

  has_many :periods, dependent: :destroy

  validates :description, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :contact_email, presence: true
  validates :name, presence: true
  validates :organisation, presence: true
  validates :start_date, presence: true

  has_attached_file :export

  def generate_xls
    xls = Spreadsheet::Workbook.new
    sheet = xls.create_worksheet

    sheet.update_row 0, "Naam", "Email", "Studentnummer", "Ticket"
    registrations.select(&:is_paid).each.with_index do |reg, i|
      sheet.update_row(i+1, reg.name, reg.email, reg.student_number, reg.access_levels.first.name)
    end
    data = File.new "export.xls", "w"

    xls.write(data)

    self.export = data
    self.save!
    data.unlink
  end

end
