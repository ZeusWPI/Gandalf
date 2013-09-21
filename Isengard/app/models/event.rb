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
  
  # attr_accessible ?

end
