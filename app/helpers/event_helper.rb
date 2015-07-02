module EventHelper
  def color_for_tickets_left(al)
    return 'default' if al.capacity.blank?

    case al.tickets_left / al.capacity.to_f
    when 0..(0.1)
      'danger'
    when (0.1)..(0.3)
      'warning'
    else
      'default'
    end
  end
end
