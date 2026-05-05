# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :club

  has_many :access_levels, dependent: :destroy
  has_many :partners, dependent: :destroy
  has_many :registrations, dependent: :destroy

  validates :description, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :contact_email, presence: true
  validates :name, presence: true
  validates :start_date, presence: true

  validates :contact_email, email: true
  validates_with IbanValidator

  validates_datetime :end_date, after: :start_date
  validates_datetime :registration_close_date, after: :registration_open_date,
                                               unless: ->(o) { o.registration_close_date.blank? or o.registration_open_date.blank? }

  has_one_attached :registration_xls

  before_save :prettify_bank_number

  def prettify_bank_number
    self.bank_number = IBANTools::IBAN.new(self.bank_number).prettify if bank_number_changed?
  end

  def toggle_registration_open
    self.toggle(:registration_open).save!
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
