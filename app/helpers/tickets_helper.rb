module TicketsHelper
  def nice_changeset(name, change)
    case name
    when 'checked_in_at'
      "Checked in at #{nice_time change[1]}"
    end
  end
end
