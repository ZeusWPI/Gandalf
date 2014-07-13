class InvitationsController < ApplicationController

  before_action do
    @event = Event.find params.require(:event_id)
    @partner = @event.partners.find params.require(:partner_id)
    authorize! :edit, @event
  end

  def index
  end

  def invite
    @access_level = @event.access_levels.find params.require(:access_level)
    new_count = params.require(:invite_count).to_i
    current = @partner.received_invitations.where access_level: @access_level
    current_count = current.count

    # can't remove delivered invites here
    min_count = current.where(delivered: true).count
    if min_count > new_count
      flash.now[:error] = "You cannot remove delivered invites."
    end
    new_count = [new_count, min_count].max

    if new_count < current_count
      # remove superfluous invites
      logger.debug("HEY HEY HEY #{new_count}")
      current.where(delivered: false).take(current_count - new_count).each do |i|
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

end
