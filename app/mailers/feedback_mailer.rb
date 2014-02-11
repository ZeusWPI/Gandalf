class FeedbackMailer < ActionMailer::Base

  def general_message(from, to, subject, body)
    mail(to: to,
         from: from,
         subject: subject,
         body: body,
         content_type: 'text/html')
  end

end
