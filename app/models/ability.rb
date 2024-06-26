# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(entity)
    # User.new is the default
    entity ||= User.new

    # Aliases
    alias_action :new, :create, :read, :update, :destroy, to: :crud

    # Delegate with user precedence
    case entity
    when User
      user_rules(entity)
    when Partner
      partner_rules(entity)
    end
  end

  def partner_rules(partner)
    # Partners can read and register
    can :read, Partner, event_id: partner.event_id, id: partner.id
    can :register, Partner, event_id: partner.event_id, id: partner.id
    can :show, Event
  end

  def user_rules(user)
    clubs = user.try(:clubs)
    enrolled_clubs = user.try(:enrolled_clubs)
    if clubs.present?
      can :create, Event
      can :show, Event
      can :crud, Event, ["club_id IN (?)", clubs.ids] do |e|
        clubs.include? e.club
      end
    else
      can :show, Event
    end

    # Admins can do anything!
    if user.admin?
      can :manage, Event
      can :manage, Registration
      can :manage, Partner
    end

    # add register permission
    can :register, Event do |event|
      if !event.registration_open
        false
      elsif event.registration_open_date.present? && event.registration_close_date.present?
        event.registration_open_date <= DateTime.now && event.registration_close_date >= DateTime.now
      elsif event.registration_open_date.present? && event.registration_close_date.blank?
        event.registration_open_date <= DateTime.now
      else
        true
      end
    end

    # can you register for an access level
    can :register, AccessLevel do |access_level|
      # not if you can't register for the event
      next false unless can? :register, access_level.event

      next false if access_level.hidden

      next enrolled_clubs.include? access_level.event.club if access_level.permit_members?
      next enrolled_clubs.any? if access_level.permit_enrolled?

      # User not logged in.
      next user.persisted? if access_level.permit_students?

      access_level.permit_everyone?
    end

    # add modify registrations permission for club members
    can :update, Registration do |registration|
      clubs.include? registration.event.club
    end

    # can view statistics?
    can :view_stats, Event do |event|
      clubs.include? event.club or event.show_statistics
    end
  end
end
