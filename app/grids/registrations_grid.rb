class RegistrationsGrid
  include Datagrid

  scope do
    Registration
  end

  filter(:name)
  filter(:email)
  # filter(:access_levels)

  column(:name)
  column(:email)
  column(:access_level) do |registration|
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
