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
      if access_level.capacity != nil and access_level.registrations.count > access_level.capacity
        record.errors.add :access_levels, "type is sold out."
        raise ActiveRecord::Rollback
      end
    end
  end

  def paid
    from_cents read_attribute(:paid)
  end

  def paid=(value)
    write_attribute :paid, to_cents(value)
  end

  def to_pay
    self.price - self.paid
  end

  def to_pay=(value)
    self.paid = self.price - (to_cents(value) / 100.0)
  end

  def price
    from_cents read_attribute(:price)
  end

  def price=(value)
    write_attribute(:price, to_cents(value))
  end

  def is_paid
    self.price == self.paid
  end

  def payment_code
    base = "GAN#{self.event.id}D#{self.id}A#{(self.event.id + self.id) % 9}L"
    base += (base.sum % 99).to_s + 'F'
  end

  private

  def from_cents(value)
    (value || nil) / 100.0
  end

  def to_cents(value)
    if value.is_a? String then value.sub!(',', '.') end
    (value.to_f * 100).to_int
  end

end
