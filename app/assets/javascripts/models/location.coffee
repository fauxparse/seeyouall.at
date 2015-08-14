class App.Location extends Spine.Model
  @configure "Location", "name", "address", "latitude", "longitude", "rooms"
  @extend Spine.Model.Ajax

  rooms: (values) ->
    if values?
      values = ($.extend(v, location_id: @id) for v in values)
      @_rooms = App.Room.refresh(values)
    @_rooms ||= []

  findRoom: (id) ->
    for room in @rooms()
      return room if room.id.toString() == id.toString()
    false

  addRoom: (attrs = {}) ->
    attrs.location_id = @id
    for r in App.Room.refresh([attrs])
      @rooms().push(r)
      return r

  removeRoom: (id) ->
    i = 0
    while i < @rooms().length
      if @_rooms[i].id.toString() == id.toString()
        @_rooms.splice(i, 1)
      else
        i += 1

  toJSON: ->
    attributes = super
    delete attributes.latitude
    delete attributes.longitude
    attributes.rooms = (room.toJSON() for room in @rooms())
    attributes

class App.Room extends Spine.Model
  @configure "Room", "name"

  location: ->
    @_location ||= App.Location.find(@location_id)

App.Room.on "destroy", (room) ->
  room.location()?.removeRoom(room.id)
