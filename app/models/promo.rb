# frozen_string_literal: true

# == Schema Information
#
# Table name: promos
#
#  id           :integer          not null, primary key
#  event_id     :integer
#  code         :string
#  limit        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  sold_tickets :integer          default(0)
#

class Promo < ApplicationRecord
  belongs_to :event
  has_and_belongs_to_many :access_levels

  validates :code, presence: true
  validates :limit, numericality: { only_integer: true, greater_than: 0 }
  validates :access_levels, presence: true

  def tickets_sold?
    self.sold_tickets != 0
  end

  def self.generate_bulk(amount, limit, access_levels, event)
    amount.times do
      promo = self.new(code: 12.times.map { SecureRandom.random_number(10) }.join,
                       limit: limit)
      promo.access_levels = access_levels
      promo.event = event
      promo.save!
    end
  end
end
