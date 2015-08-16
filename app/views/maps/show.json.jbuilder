json.key_format! :dasherize

json.type "FeatureCollection"
json.features event.locations do |location|
  json.type "Feature"

  json.properties do
    json.marker_color "#E91E63"
    json.name         location.name
    json.address      location.address
    json.rooms        location.rooms.map(&:name)
  end

  json.geometry do
    json.type "Point"
    json.coordinates [ location.longitude, location.latitude ]
  end
end
