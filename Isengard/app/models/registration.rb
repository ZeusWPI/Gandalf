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

  before_save :set_cents

  def paid
    if paid_cents
      paid_cents / 100.0
    else
      0
    end
  end

  def set_cents
    self.paid_cents = (self.paid_cents * 100).to_int
  end

  def is_paid
    self.price == self.paid
  end

end
