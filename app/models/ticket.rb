# == Schema Information
#
# Table name: tickets
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
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
#  status          :string(255)      default("initial")
#

class Ticket < ActiveRecord::Base
  belongs_to :event
  belongs_to :order
  belongs_to :access_level

  has_paper_trail only: [:checked_in_at]

  # A ticket should have an access_level set
  validates :access_level, presence: true
  # The name should only be unique for member only tickets in the same event
  validates :name, presence: true, uniqueness: { scope: :event_id }, if: Proc.new { |t| t.access_level.member_only and t.parent_add_ticket_info? }
  # Same for email
  validates :email, presence: true, uniqueness: { scope: :event_id }, email: true, if: Proc.new { |t| t.access_level.member_only and t.parent_add_ticket_info? }

  validates :student_number,
    format: {with: /\A[0-9]*\Z/, message: "has invalid format" },
    uniqueness: { scope: :event }, allow_blank: true,
    if: :parent_add_ticket_info?

  after_save do |ticket|
    al = ticket.access_level
    if al.capacity != nil and al.tickets.count > al.capacity
      ticket.errors.add :access_level, "type is sold out."
      raise ActiveRecord::Rollback
    end
  end

  def initial?
    status == 'initial'
  end

  def active?
    status == 'active'
  end

  def parent_add_ticket_info?
    self.order.active_or_add_ticket_info?
  end

  def generate_barcode
    self.barcode_data = 12.times.map { SecureRandom.random_number(10) }.join
    calculated_barcode = Barcodes.create('EAN13', data: self.barcode_data)
    self.barcode = calculated_barcode.caption_data
    self.save!
  end

end
