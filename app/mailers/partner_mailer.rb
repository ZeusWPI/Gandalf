# frozen_string_literal: true

class PartnerMailer < ApplicationMailer
  def send_token(partner)
    @partner = partner
    mail to: "#{partner.name} <#{partner.email}>", subject: "Partner token for #{partner.name}"
  end

  def invitation(partner)
    @partner = partner
    mail to: "#{partner.name} <#{partner.email}>", subject: "Invitation for #{partner.name}"
  end
end
