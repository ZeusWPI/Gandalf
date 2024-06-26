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
