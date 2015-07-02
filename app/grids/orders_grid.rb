class OrdersGrid
  include Datagrid

  scope do
    Order.active
  end

  # We use the lower() instead of ilike because SQLite dev doesn't like ilike
  filter(:name) { |value| where('lower(orders.name) like ?', "%#{value.downcase}%") }
  filter(:email) { |value| where('lower(orders.email) like ?', "%#{value.downcase}%") }
  filter(:payment_code) { |value| where('orders.payment_code like ?', "%#{value}%") }
  filter(:only_paid) { |value| where('orders.paid = orders.price')  if value == '1' }
  filter(:only_unpaid) { |value| where.not('orders.paid = orders.price')  if value == '1' }

  column(:name)
  column(:email)
  column(:payment_code)
  column(:to_pay, html: true, order: 'orders.price - paid', descending: true) do |order|
    render partial: 'order_payment_form', locals: { order: order }
  end
  column(:actions, html: true) do |order|
    render partial: 'order_actions', locals: { order: order }
  end
end
