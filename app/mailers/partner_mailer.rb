class PartnerMailer < ActionMailer::Base
  default from: "noreply@event.fkgent.be"

  def send_token(partner)
    @partner = partner
    mail to: address(partner), subject: "Partner token for #{partner.name}"
  end

  def invitation(invitation)
    @invitation = invitation
    mail to: address(@invitation.invitee), subject: "Invitation for #{@invitation.invitee}"
  end

  private

  def address(partner)
    "#{partner.name} <#{partner.email}>"
  end

end
