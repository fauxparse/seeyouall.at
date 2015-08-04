class Ability < Struct.new(:user)
  include CanCan::Ability

  def initialize(user)
    super

    can :read, Event

    if user.present?
      can :create, Event

      can :manage, Event do |event|
        administrator_of?(event)
      end

      can :manage, Activity do |activity|
        administrator_of?(activity.event)
      end
    end
  end

  def administrator_of?(event)
    event.administrators.where("user_id = ?", user.id).exists?
  end
end
