# == Schema Information
#
# Table name: registrations
#
#  id             :integer          not null, primary key
#  barcode        :integer
#  name           :string(255)
#  email          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  event_id       :integer
#  paid           :integer
#  student_number :string(255)
#  price          :integer
#

class Registration < ActiveRecord::Base
  belongs_to :event
  has_many :accesses, dependent: :destroy
  has_many :access_levels, through: :accesses

  validates :name, presence: true
  validates :email, presence: true
  validates :student_number, presence: true, format: {with: /\A[0-9]*\Z/, message: "has invalid format" }
  validates :paid, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_save do |record|
    record.access_levels.each do |access_level|
      unless access_level.registrations.count <= access_level.capacity
        record.errors.add :access_levels, "type is sold out."
      end
    end
    not record.errors.any?
  end

  def paid
    (read_attribute(:paid) || 0) / 100.0
  end

  def paid=(value)
    if value.is_a? String then value.sub!(',', '.') end
    write_attribute(:paid, (value.to_f * 100).to_int)
  end

  def price
    (read_attribute(:price) || 0) / 100.0
  end

  def price=(value)
    if value.is_a? String then value.sub!(',', '.') end
    write_attribute(:price, (value.to_f * 100).to_int)
  end

  def is_paid
    self.price == self.paid
  end

end
