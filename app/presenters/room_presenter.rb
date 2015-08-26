class RoomPresenter < SimpleDelegator
  alias_method :room, :__getobj__

  delegate :address, to: :location

  def to_s
    if name == location.name
      name
    else
      "#{name} @ #{location.name}"
    end
  end
end
