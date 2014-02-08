class RegistrationsGrid
  include Datagrid

  scope do
    Registration
  end

  # We use the lower() instead of ilike because SQLite dev doesn't like ilike
  filter(:name) { |value| where("lower(?) like ?", :name, "%#{value.downcase}%") }
  filter(:email) { |value| where("lower(?) like ?", :email, "%#{value.downcase}%") }
  filter(:access_level) { |value, scope| scope.joins(:access_levels).where(access_levels: { id: value }) }

  column(:name)
  column(:email)
  column(:access_level, header: "Ticket") do |registration|
    registration.access_levels.first.try :name
  end
  column(:payment_code)
  column(:to_pay, html: true) do |registration|
    render partial: 'registration_payment_form', locals: { registration: registration }
  end
  column(:actions, html: true) do |registration|
    render partial: 'registration_actions', locals: { registration: registration }
  end
end
