module RegistrationsHelper

  def nice_changeset(name, change)
    case name
    when 'paid'
      "Changed the amount paid from #{euro(@registration.price - change[0])} to #{euro(@registration.price - change[1])}"
    when 'checked_in_at'
      "Checked in at #{nice_time change[1]}"
    when 'random_check'
      base = "GAN#{@registration.event_id}D#{@registration.id}A#{(@registration.event_id + @registration.id) % 9}L"
      base += "#{base.sum % 99}F#{change[1]}"
      "Payment code updated to #{base}"
    end
  end

end
