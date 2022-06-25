# frozen_string_literal: true

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

class Event < ApplicationRecord
  belongs_to :club

  has_many :access_levels, dependent: :destroy
  has_many :partners, dependent: :destroy
  has_many :zones, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :promos, dependent: :destroy

  has_many :periods, dependent: :destroy

  validates :description, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :contact_email, presence: true
  validates :name, presence: true
  validates :club, presence: true
  validates :start_date, presence: true

  validates :contact_email, email: true
  validates_with IbanValidator

  validates_datetime :end_date, after: :start_date
  validates_datetime :registration_close_date, after: :registration_open_date,
    unless: lambda { |o| o.registration_close_date.blank? or o.registration_open_date.blank? }

  has_one_attached :registration_xls

  before_save :prettify_bank_number

  def prettify_bank_number
    self.bank_number = IBANTools::IBAN.new(self.bank_number).prettify if bank_number_changed?
  end

  def toggle_registration_open
    self.toggle!(:registration_open)
  end
end
