# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  status     :string(255)
#  name       :string(255)
#  email      :string(255)
#  gsm        :string(255)
#  ticket_id  :integer
#  event_id   :integer
#  paid       :integer
#  price      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Order < ActiveRecord::Base
  belongs_to :event
  has_many :ticket

  scope :paid, -> { where("price <= paid") }

  validates :paid, presence: true, numericality: { only_integer: true }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :payment_code, presence: true, uniqueness: true

  default_scope { order "name ASC" }

  before_validation do |record|
    if record.payment_code.nil? then
      record.payment_code = self.class.create_payment_code
    end
  end

  def active?
    status == 'active'
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
    self.price <= self.paid
  end

  def self.find_payment_code_from_csv(csvline)
    match = /GAN\d+/.match(csvline)
    if match
      return self.class.find_by_payment_code(match[0])
    else
      return false
    end
  end

  def self.create_payment_code
    random = rand(10**15)
    return sprintf("GAN%02d%015d", random % 97, random)
  end

  def deliver
    if self.barcode.nil?
      self.generate_barcode
    end

    if self.is_paid
      OrderMailer.ticket(self).deliver
    else
      OrderMailer.confirm_order(self).deliver
    end
  end

  private

  def from_cents(value)
    (value || 0) / 100.0
  end

  def to_cents(value)
    if value.is_a? String then value.sub!(',', '.') end
    (value.to_f * 100).to_int
  end
end