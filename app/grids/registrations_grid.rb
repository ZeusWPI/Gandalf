class RegistrationsGrid
  include Datagrid

  scope do
    Registration
  end

  # We use the lower() instead of ilike because SQLite dev doesn't like ilike
  filter(:name) { |value| where("lower(?) like ?", :name, "%#{value.downcase}%") }
  filter(:email) { |value| where("lower(?) like ?", :email, "%#{value.downcase}%") }
  filter(:access_level) { |value, scope| scope.joins(:access_levels).where(access_levels: { id: value }) }
  filter(:payment_code) { |value| where("? like ?", :payment_code, "%#{value}%") }
  filter(:only_paid) { |value| where("paid = price")  if value == '1' }
  filter(:only_unpaid) { |value| where.not("paid = price")  if value == '1' }

  column(:name)
  column(:email)
  column(:access_level, header: "Ticket", order: proc { |scope|
    scope.joins(:accesses).joins(:access_levels).order("access_levels.name")
  }) do |registration|
    registration.access_levels.first.try :name
  end
  column(:payment_code)
  column(:to_pay, html: true, order: "registrations.price - paid", descending: true) do |registration|
    render partial: 'registration_payment_form', locals: { registration: registration }
  end
  column(:actions, html: true) do |registration|
    render partial: 'registration_actions', locals: { registration: registration }
  end
end
