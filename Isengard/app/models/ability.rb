class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :new, :create, :read, :update, :destroy, :to => :crud

    club = user.try(:club)
    if !club.blank?
      can :create, Event
      can :show, Event
      can :crud, Event, club: club
    else
      can :show, Event
    end
    # add register permission
    can :register, Event do |event| 
      if !(event.registration_open_date.blank? || event.registration_close_date.blank?)
        event.registration_open_date <= DateTime.now && event.registration_close_date >= DateTime.now
      else
        true
      end
    end

    # add modify registrations permission for club members
    can :update, Registration do |registration|
      registration.event.club == club
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

end
