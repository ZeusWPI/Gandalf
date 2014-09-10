json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :name, :email, :gsm, :checked_in_at, :event_id, :order_id, :student_number, :comment, :barcode, :barcode_data
  json.url ticket_url(ticket, format: :json)
end
