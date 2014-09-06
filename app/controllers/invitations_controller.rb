class InvitationsController < ApplicationController

  before_action do
    @event = Event.find params.require(:event_id)
    @partner = @event.partners.find params.require(:partner_id)
  end

  before_action only: [:accept, :select, :deselect] do
    @invitation = @partner.received_invitations.find params.require(:id)
  end

  def index
    authorize! :edit, @event
  end

  def invite
    authorize! :edit, @event

    @access_level = @event.access_levels.find params.require(:access_level)
    new_count = params.require(:invite_count).to_i
    current = @partner.received_invitations.where access_level: @access_level
    current_count = current.count

    # can't remove selected invites here
    min_count = current.where(selected: true).count
    if min_count > new_count
      flash.now[:error] = "You cannot remove selected invites."
    end
    new_count = [new_count, min_count].max

    if new_count < current_count
      # remove superfluous invites
      logger.debug("HEY HEY HEY #{new_count}")
      current.where(selected: false).take(current_count - new_count).each do |i|
        i.destroy
      end
      flash.now[:success] = "#{@access_level.name} invitations removed"
    else
      # add new invites
      (new_count - current_count).times do
        invitation = @partner.received_invitations.create(
          inviter_id: nil,
          comment: nil,
          paid: @access_level.price,
          price: @access_level.price,
          access_level: @access_level
        )
        invitation.save!
      end
      flash.now[:success] = "#{@access_level.name} invitations added"
    end
  end

  def accept
    # TODO repalce after manual testing
    #authorize! :register, @partner

    if @invitation.accepted
      flash.now[:error] = "This invitation has been accepted before."
    else
      @registration = @event.registrations.new(
        email:          @partner.email,
        name:           @partner.name,
        student_number: nil,
        comment:        @invitation.comment,
        price:          @invitation.price,
        paid:           @invitation.paid
      )
      @registration.access_levels << @invitation.access_level
      @invitation.accepted = true
      if @registration.save and @invitation.save then
        @registration.deliver
        flash.now[:success] = "Your invitation has been accepted. Your ticket should arrive shortly."
      else
        # TODO invitation may be accepted twice if the invitation.save fails
        flash.now[:error] = "Is seems there already is someone with your name and/or email registered for this event. #{view_context.mail_to @event.contact_email, "Contact us"} if this is not correct.".html_safe
      end
    end
    render "partners/show"
  end

  def select
    @invitation.update selected: true
    render "partners/show"
  end

  def deselect
    @invitation.update selected: false
    render "partners/show"
  end

  def pass
    # TODO specific ability? No --> Every partner can pass on his invitations.

    p = params.permit(:email, :name)
    @invitee = @event.partners.new p
    if @invitee.save
      all_success = @partner.received_invitations.where(selected: true).map do |invitation|
        invitation.update(invitee_id: @invitee.id, inviter_id: @partner.id, selected: false, accepted: false)
      end.all?

      if all_success
        flash.now[:success] = "Passed on the invitation successfully."
        # TODO mail new partner he has pending invitations
      else
        flash.now[:error] = "Failed to send some invitations to this partner."
      end
    else
      flash.now[:error] = "Failed to create such a partner."
    end

    render "partners/show"
  end

end
