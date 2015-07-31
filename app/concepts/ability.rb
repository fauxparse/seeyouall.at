class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Event

    if user.present?
      can :create, Event

      can :manage, Event do |event|
        event.administrators.where("user_id = ?", user.id).exists?
      end
    end
  end
end
