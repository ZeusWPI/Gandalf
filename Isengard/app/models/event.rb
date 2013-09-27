# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  start_date   :datetime
#  end_date     :datetime
#  location     :string(255)
#  website      :string(255)
#  description  :text
#  organisation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Event < ActiveRecord::Base

  has_many :access_levels
  has_many :zones
  has_many :registrations
  has_many :roles

  validates :description, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :name, presence: true
  validates :organisation, presence: true
  validates :start_date, presence: true

end
