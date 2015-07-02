# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  status       :string           default("initial")
#  name         :string
#  email        :string
#  gsm          :string
#  ticket_id    :integer
#  event_id     :integer
#  paid         :integer
#  price        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  payment_code :string
#

class Order < ActiveRecord::Base
  belongs_to :event
  has_many :tickets

  scope :paid, -> { where('price <= paid') }
  scope :active, -> { where(status: 'active') }

  has_paper_trail only: [:paid, :payment_code]

  # Should validate on add_tickets
  validates :tickets, presence: { message: 'is empty! Please pick at least one.' }, if: :active_or_add_tickets?

  # Should validate on add_info
  validates :name, presence: true, if: :active_or_add_info?
  # This should be a setting per event basis
  # validates :gsm, presence: true, if: :active_or_add_info?
  validates :email, email: true, presence: true, confirmation: true, if: :active_or_add_info?

  # Should validate on add_ticket_info
  validates_associated :tickets, if: :active_or_add_ticket_info?

  # Should validate on pay
  validates :paid, presence: true, numericality: { only_integer: true }, if: :active_or_pay?
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, if: :active_or_pay?
  validates :payment_code, presence: true, uniqueness: true, if: :active_or_pay?

  default_scope { order 'name ASC' }

  before_validation do |record|
    if record.payment_code.nil?
      record.payment_code = self.class.create_payment_code
    end
  end

  # Wicked methods
  def active?
    status == 'active'
  end

  def active_or_add_tickets?
    status.include?('add_tickets') || active?
  end

  def active_or_add_info?
    status.include?('add_info') || active?
  end

  def active_or_add_ticket_info?
    status.include?('add_ticket_info') || active?
  end

  def active_or_pay?
    status.include?('pay') || active?
  end

  def paid
    from_cents self[:paid]
  end

  def paid=(value)
    self[:paid] = to_cents(value)
  end

  def to_pay
    price - paid
  end

  def to_pay=(value)
    self.paid = price - (to_cents(value) / 100.0)
  end

  def price
    from_cents self[:price]
  end

  def price=(value)
    self[:price] = to_cents(value)
  end

  def is_paid
    price <= paid
  end

  def self.find_payment_code_from_csv(csvline)
    match = /GAN\d+/.match(csvline)
    if match
      return Order.find_by_payment_code(match[0])
    else
      return false
    end
  end

  def self.create_payment_code
    random = rand(10**15)
    sprintf('GAN%02d%015d', random % 97, random)
  end

  def deliver
    if is_paid
      tickets.all.map(&:deliver)
      OrderMailer.notify_overpayment(self).deliver_now if paid > price
    else
      OrderMailer.confirm_order(self).deliver_now
    end
  end

  private

  def from_cents(value)
    (value || 0) / 100.0
  end

  def to_cents(value)
    value.sub!(',', '.') if value.is_a? String
    (value.to_f * 100).to_int
  end
end
