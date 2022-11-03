# frozen_string_literal: true

module EventHelper
  def color_for_tickets_left(access_level)
    return "default" if access_level.capacity.blank?

    case access_level.tickets_left / access_level.capacity.to_f
    when 0..0.1
      "danger"
    when 0.1..0.3
      "warning"
    else
      "default"
    end
  end
end
