# == Schema Information
#
# Table name: registrations
#
#  id         :integer          not null, primary key
#  barcode    :integer
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  event_id   :integer
#

class Registration < ActiveRecord::Base
  belongs_to :event
  has_many :accesses, dependent: :destroy
  has_many :access_levels, through: :accesses

  validates :name, presence: true
  validates :email, presence: true
  validates :student_number, presence: true, format: {with: /\A[0-9]*\Z/, message: "has invalid format" }

  def paid
    if read_attribute(:paid) then read_attribute(:paid) / 100.0 else 0 end
  end

  def paid=(amount)
    write_attribute(:paid, (Float(amount) * 100).to_int)
  end

  def price
    if read_attribute(:price) then read_attribute(:price) / 100.0 else 0 end
  end

  def price=(amount)
    write_attribute(:price, (Float(amount) * 100).to_int)
  end

  def is_paid
    self.price == self.paid
  end

end
