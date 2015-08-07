class Ability < Struct.new(:user)
  include CanCan::Ability

  def initialize(user)
    super

    can :read, [Event, EventPresenter]

    if user.present?
      can :create, [Event, EventPresenter]

      can :manage, [Event, EventPresenter] do |event|
        administrator_of?(event)
      end

      can :manage, [Activity, ActivityType, TimeSlot] do |resource|
        administrator_of?(resource.event)
      end

      can :manage, [Registration, RegistrationPresenter] do |registration|
        user == registration.user || administrator_of?(registration.event)
      end
    end
  end

  def administrator_of?(event)
    event.administrators.where("user_id = ?", user.id).exists?
  end
end
