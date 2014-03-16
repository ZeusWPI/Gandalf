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
#  export_status           :string(255)
#  show_statistics         :boolean
#  club_id                 :integer
#  registration_open       :boolean          default(TRUE)
#

class Event < ActiveRecord::Base

  belongs_to :club

  has_many :access_levels, dependent: :destroy
  has_many :partners, dependent: :destroy
  has_many :zones, dependent: :destroy
  has_many :registrations, dependent: :destroy

  has_many :periods, dependent: :destroy

  validates :description, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :contact_email, presence: true
  validates :name, presence: true
  validates :club, presence: true
  validates :start_date, presence: true

  validates :contact_email, email: true
  validates_with IBANValidator

  has_attached_file :export

  before_save :prettify_bank_number

  def prettify_bank_number
    self.bank_number = IBANTools::IBAN.new(self.bank_number).prettify if bank_number_changed?
  end

  def generate_xls
    self.export_status = 'generating'
    self.save
    xls = Spreadsheet::Workbook.new
    sheet = xls.create_worksheet

    sheet.update_row 0, "Naam", "Email", "Studentnummer", "Ticket", "Comment"
    registrations.select(&:is_paid).each.with_index do |reg, i|
      sheet.update_row i + 1, reg.name, reg.email, reg.student_number, reg.access_levels.first.name, reg.comment
    end
    data = Tempfile.new(["export", ".xls"])

    xls.write(data)

    self.export = data
    self.export_status = 'done'
    self.save!
    data.close
  end
  handle_asynchronously :generate_xls

  def toggle_registration_open
    self.registration_open = !self.registration_open
    self.save
  end
end
