# frozen_string_literal: true

# == Schema Information
#
# Table name: access_levels
#
#  id          :integer          not null, primary key
#  capacity    :integer
#  has_comment :boolean
#  hidden      :boolean
#  name        :string
#  permit      :string           default("everyone")
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#  event_id    :integer
#
# Indexes
#
#  index_access_levels_on_event_id  (event_id)
#

class AccessLevel < ApplicationRecord
  belongs_to :event, optional: true

  has_many :included_zones, dependent: :destroy
  has_many :zones, through: :included_zones

  has_many :accesses, dependent: :destroy
  has_many :registrations, through: :accesses
  has_many :partners

  has_and_belongs_to_many :promos

  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :capacity, numericality: { allow_nil: true, only_integer: true, greater_than: 0 }

  validate do |access_level|
    access_level.errors.add :event_id, "has no bank number." if access_level.price.positive? && access_level.event.bank_number.blank?
  end

  default_scope { order "price, name" }
  scope :public?, -> { where(hidden: false) }

  as_enum :permit, %w[everyone students enrolled members], prefix: true, source: :permit, map: :string

  def requires_login?
    !permit_everyone?
  end

  def zones_by_ids=(zones)
    self.zones = self.event.zones.find zones
    self.save!
  end

  def name_with_price
    if price.positive?
      "#{name} - €#{format('%0.2f', price)}"
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
    value.sub!(',', '.') if value.is_a? String
    write_attribute(:price, (value.to_f * 100).to_int)
  end
end
