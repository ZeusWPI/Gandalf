# coding: utf-8
# == Schema Information
#
# Table name: access_levels
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  event_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  capacity    :integer
#  price       :integer
#  public      :boolean          default(TRUE)
#  has_comment :boolean
#  hidden      :boolean
#  member_only :boolean
#

class AccessLevel < ActiveRecord::Base
  belongs_to :event

  has_many :included_zones, dependent: :destroy
  has_many :zones, through: :included_zones

  has_many :accesses, dependent: :destroy
  has_many :registrations, through: :accesses

  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :capacity, numericality: { allow_nil: true, only_integer: true, greater_than: 0 }

  validate do |access_level|
    if access_level.price > 0 and access_level.event.bank_number.blank?
      access_level.errors.add :event_id, "has no bank number."
    end
  end

  default_scope { order "price, name" }
  scope :public, -> { where(public: true) }

  def set_zones_by_ids zones
    self.zones = self.event.zones.find zones
    self.save
  end

  def name_with_price
    if price > 0
      "#{name} - €#{'%0.2f' % price}"
    else
       name
    end
  end

  def tickets_left
    capacity - registrations.count if capacity.presence
  end

  def price
    (read_attribute(:price) || 0) / 100.0
  end

  def price=(value)
    if value.is_a? String then value.sub!(',', '.') end
    write_attribute(:price, (value.to_f * 100).to_int)
  end

end
