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

  has_many :access_levels, dependent: :destroy
  has_many :zones, dependent: :destroy
  has_many :registrations, dependent: :destroy

  has_many :roles, dependent: :destroy
  has_many :people, through: :roles

  has_many :periods, dependent: :destroy

  validates :description, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :name, presence: true
  validates :organisation, presence: true
  validates :start_date, presence: true

end
