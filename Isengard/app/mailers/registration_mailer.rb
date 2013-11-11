class RegistrationMailer < ActionMailer::Base
  default from: "noreply@event.fkgent.be"

  def confirm_registration(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: "Registration for #{registration.event.name}"
  end

end
