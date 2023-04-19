# frozen_string_literal: true

class GenerateIcal
  def initialize(event)
    @event = event
  end

  def call
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart = @event.start_date
      e.dtend = @event.end_date
      e.location = @event.location
      e.summary = @event.name
      e.description = @event.website
      e.organizer = "mailto:#{@event.contact_email}"
      e.organizer = Icalendar::Values::CalAddress.new("mailto:#{@event.contact_email}", cn: @event.club.name)
    end
    cal.publish
    cal.to_ical
  end
end
