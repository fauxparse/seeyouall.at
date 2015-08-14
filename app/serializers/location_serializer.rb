class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :latitude, :longitude, :rooms

  def rooms
    object.rooms.map { |room| RoomSerializer.new(room).attributes }
  end
end
