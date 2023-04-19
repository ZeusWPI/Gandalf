# frozen_string_literal: true

class RegistrationsGrid
  include Datagrid

  scope do
    Registration
  end

  # We use the lower() instead of ilike because SQLite dev doesn't like ilike
  filter(:name) { |value| where("lower(registrations.name) like ?", "%#{value.downcase}%") }
  filter(:email) { |value| where("lower(registrations.email) like ?", "%#{value.downcase}%") }
  filter(:access_level) { |value, scope| scope.where(access_level_id: value) }
  filter(:payment_code) { |value| where("registrations.payment_code like ?", "%#{value}%") }
  filter(:only_paid) { |value| where("registrations.paid = registrations.price") if value == '1' }
  filter(:only_unpaid) { |value| where.not("registrations.paid = registrations.price") if value == '1' }

  column(:name)
  column(:email)
  column(:created_at) do |registration|
    registration.created_at.to_formatted_s(:long)
  end
  column(:access_level, header: "Ticket", order: proc { |scope|
    scope.joins(:access_level).order("access_levels.name")
  }) do |registration|
    registration.access_level.name
  end
  column(:payment_code)
  column(:to_pay, html: true, order: Arel.sql("price - paid"), descending: true) do |registration|
    render partial: 'registration_payment_form', locals: { registration: registration }
  end
  column(:actions, html: true) do |registration|
    render partial: 'registration_actions', locals: { registration: registration }
  end
end
