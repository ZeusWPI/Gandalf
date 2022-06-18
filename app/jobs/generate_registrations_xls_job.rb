class GenerateRegistrationsXlsJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find(event_id)

    event.update!(export_status: 'generating')

    xls = Spreadsheet::Workbook.new

    sheet = xls.create_worksheet
    sheet.update_row 0, "Naam", "Email", "Studentnummer", "Ticket", "Comment", "Te betalen"
    event.registrations.each.with_index do |reg, i|
      sheet.update_row i + 1, reg.name, reg.email, reg.student_number, reg.access_levels.first.name, reg.comment, reg.to_pay
    end

    file = Tempfile.new
    xls.write(file)

    event.registration_xls.attach(io: file.open, filename: 'export.xls')
    event.update!(export_status: 'done')

    file.close
  end
end
