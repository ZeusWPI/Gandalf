# == Schema Information
#
# Table name: registrations
#
#  id             :integer          not null, primary key
#  barcode        :string(255)
#  name           :string(255)
#  email          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  event_id       :integer
#  paid           :integer
#  student_number :string(255)
#  price          :integer
#  checked_in_at  :datetime
#  comment        :text
#  barcode_data   :string(255)
#  payment_code   :string(255)
#

class Registration < ActiveRecord::Base
  belongs_to :event
  has_many :accesses, dependent: :destroy
  has_many :access_levels, through: :accesses

  validates :name, presence: true
  validates :email, presence: true
  validates :student_number, presence: true, format: {with: /\A[0-9]*\Z/, message: "has invalid format" }
  validates :paid, presence: true, numericality: { only_integer: true }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :payment_code, presence: true, uniqueness: true

  has_paper_trail only: [:paid, :random_check, :checked_in_at]

  after_save do |record|
    record.access_levels.each do |access_level|
      if access_level.capacity != nil and access_level.registrations.count > access_level.capacity
        record.errors.add :access_levels, "type is sold out."
        raise ActiveRecord::Rollback
      end
    end
  end

  default_scope { order "name ASC" }

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
    renew_payment_code
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

  def generate_barcode
    self.barcode_data = 12.times.map { SecureRandom.random_number(10) }.join
    calculated_barcode = Barcodes.create('EAN13', data: self.barcode_data)
    self.barcode = calculated_barcode.caption_data
    self.save!
  end

  def self.search_payment_code(string)
    match = /GAN\d+/.match(string)
    if match
      return true, Registration.find_by_payment_code(match[0])
    else
      return false, nil
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

  def renew_payment_code
    random = rand(10**15)
    check = random % 99
    self.payment_code = sprintf("GAN%02d%015d", check, random)
  end

end
