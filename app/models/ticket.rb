# == Schema Information
#
# Table name: tickets
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  gsm             :string(255)
#  checked_in_at   :datetime
#  event_id        :integer
#  order_id        :integer
#  student_number  :string(255)
#  comment         :text
#  barcode         :string(255)
#  barcode_data    :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  access_level_id :integer
#

class Ticket < ActiveRecord::Base
  belongs_to :event
  belongs_to :order
  has_one :access_level

  has_paper_trail only: [:checked_in_at]

  validates :name, presence: true, uniqueness: { scope: :event_id }
  # Uniqueness temporarily disabled; see the Partner model for the reason
  #validates :email, presence: true, uniqueness: { scope: :event_id }
  validates :email, presence: true, email: true
  validates :student_number,
    format: {with: /\A[0-9]*\Z/, message: "has invalid format" },
    uniqueness: { scope: :event }, allow_blank: true

  default_scope { order "name ASC" }

  def generate_barcode
    self.barcode_data = 12.times.map { SecureRandom.random_number(10) }.join
    calculated_barcode = Barcodes.create('EAN13', data: self.barcode_data)
    self.barcode = calculated_barcode.caption_data
    self.save!
  end

end
