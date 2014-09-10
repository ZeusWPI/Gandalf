json.array!(@orders) do |order|
  json.extract! order, :id, :status, :name, :email, :gsm, :ticket_id, :event_id, :paid, :price
  json.url order_url(order, format: :json)
end
