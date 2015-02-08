# == Schema Information
#
# Table name: tickets
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  checked_in_at   :datetime
#  order_id        :integer
#  student_number  :string
#  comment         :text
#  barcode         :string
#  barcode_data    :string
#  created_at      :datetime
#  updated_at      :datetime
#  access_level_id :integer
#  status          :string           default("initial")
#

class Ticket < ActiveRecord::Base
  has_one :event, through: :order
  belongs_to :order
  belongs_to :access_level

  has_paper_trail only: [:checked_in_at]

  scope :active, -> { where(status: 'active') }
  default_scope { order(:id) }

  # A ticket should have an access_level set
  validates :access_level, presence: true

  # NAME VALIDATION
  # name should always be present
  validates :name, uniqueness: { scope: [:order, :access_level] }, presence: true, if: :parent_add_ticket_info?
  # a user cannot order a ticket which name already exists in a valid order in the event
  validates :name, uniqueness: { scope: :event }, if: Proc.new { |t| t.access_level.member_only && t.order.active? }

  # EMAIL VALIDATION
  # email should always be present
  validates :email, presence: true, if: :parent_add_ticket_info?

  validates :student_number,
    format: {with: /\A[0-9]*\Z/, message: "has invalid format" },
    uniqueness: { scope: :event }, presence: true,
    if: Proc.new { |t| t.access_level.member_only && t.order.active? }

  # after_save do |ticket|
  #   al = ticket.access_level
  #   if al.capacity != nil and al.tickets.count > al.capacity
  #     ticket.errors.add :access_level, "type is sold out."
  #     raise ActiveRecord::Rollback
  #   end
  # end

  def initial?
    status == 'initial'
  end

  def filled_in?
    status == 'filled_in'
  end

  def active?
    status == 'active'
  end

  def parent_add_ticket_info?
    self.order.active_or_add_ticket_info?
  end

  def deliver
    if self.barcode.nil?
      self.generate_barcode
    end

    TicketMailer.ticket(self).deliver
  end

  def generate_barcode
    self.barcode_data = 12.times.map { SecureRandom.random_number(10) }.join
    calculated_barcode = Barcodes.create('EAN13', data: self.barcode_data)
    self.barcode = calculated_barcode.caption_data
    self.save!
  end

end
