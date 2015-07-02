class MassMailer < ActionMailer::Base
  default from: 'noreply@event.fkgent.be'

  def general_message(from, to, subject, body)
    mail(to: "Undisclosed recipients <#{from}>",
         subject: subject,
         body: body,
         content_type: 'text/html',
         bcc: to)
  end
end
