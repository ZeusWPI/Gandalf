module OrdersHelper
  def nice_changeset(name, change)
    case name
    when 'paid'
      "Changed the amount paid from #{euro(@registration.price - change[0] / 100)} to #{euro(@registration.price - change[1])}"
    when 'payment_code'
      "Payment code updated to #{change[1]}"
    end
  end
end
