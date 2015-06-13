module RegistrationsHelper

  def nice_changeset(name, change)
    case name
    when 'paid'
      "Changed the amount paid from #{euro(@registration.price - change[0]/100)} to #{euro(@registration.price - change[1])}"
    when 'checked_in_at'
      "Checked in at #{nice_time change[1]}"
    when 'payment_code'
      "Payment code updated from #{change[0]} to #{change[1]}"
    end
  end

end
