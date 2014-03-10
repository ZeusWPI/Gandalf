class PartnerMailer < ActionMailer::Base
  default from: "noreply@event.fkgent.be"

  def send_token(partner)
    @partner = partner
    mail to: address(partner), subject: "Partner token for #{partner.name}"
  end

  def invitation(partner, invitation)
    @partner = partner
    @invitation = invitation
    mail to: address(partner), subject: "Invitation for #{partner.name}"
  end

  private

  def address(partner)
    "#{partner.name} <#{partner.email}>"
  end

end
