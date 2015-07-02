class TicketsGrid
  include Datagrid

  scope do
    Ticket.active
  end

  # We use the lower() instead of ilike because SQLite dev doesn't like ilike
  filter(:name) { |value| where('lower(tickets.name) like ?', "%#{value.downcase}%") }
  filter(:email) { |value| where('lower(tickets.email) like ?', "%#{value.downcase}%") }
  filter(:access_level) { |value, scope| scope.joins(:access_levels).where(access_levels: { id: value }) }

  column(:name)
  column(:email)
  column(:access_level, header: 'Ticket', order: proc do |scope|
    scope.joins(:access_levels).order('access_levels.name')
  end) do |ticket|
    ticket.access_level.try :name
  end
  column(:actions, html: true) do |ticket|
    render partial: 'ticket_actions', locals: { ticket: ticket }
  end
end
