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

class Event < ActiveRecord::Base
  belongs_to :club

  has_many :access_levels, dependent: :destroy
  has_many :partners, dependent: :destroy
  has_many :tickets, through: :orders
  has_many :orders, dependent: :destroy
  has_many :promos, dependent: :destroy

  validates :description, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :contact_email, presence: true
  validates :name, presence: true
  validates :club, presence: true
  validates :start_date, presence: true

  validates :contact_email, email: true
  validates_with IBANValidator

  validates_datetime :end_date, after: :start_date
  validates_datetime :registration_close_date, after: :registration_open_date,
                                               unless: ->(o) { o.registration_close_date.blank? || o.registration_open_date.blank? }

  has_attached_file :export
  validates_attachment_file_name :export, matches: /.*/
  validates_attachment_content_type :export, content_type: /.*/

  before_save :prettify_bank_number

  def prettify_bank_number
    self.bank_number = IBANTools::IBAN.new(bank_number).prettify if bank_number_changed?
  end

  def generate_xls
    self.export_status = 'generating'
    save
    xls = Spreadsheet::Workbook.new
    sheet = xls.create_worksheet

    sheet.update_row 0, 'Naam', 'Email', 'Studentnummer', 'Ticket', 'Comment', 'Te betalen'
    tickets.each.with_index do |ticket, i|
      sheet.update_row i + 1, ticket.name, ticket.email, ticket.student_number, ticket.access_level.name, ticket.comment, ticket.order.to_pay
    end
    data = Tempfile.new(['export', '.xls'])

    xls.write(data)

    self.export = data
    self.export_status = 'done'
    self.save!
    data.close
  end
  handle_asynchronously :generate_xls

  def toggle_registration_open
    self.registration_open = !registration_open
    save
  end
end
