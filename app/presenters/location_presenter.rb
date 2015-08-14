class LocationPresenter < SimpleDelegator
  alias_method :location, :__getobj__

  def to_s
    location.name
  end

  def rooms
    location.rooms.map { |room| RoomPresenter.new(room) }
  end
end
