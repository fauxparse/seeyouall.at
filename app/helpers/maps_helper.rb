module MapsHelper
  def google_maps_link(address)
    "https://www.google.com/maps/place/#{u(address)}"
  end
  
  def directions_to(address)
    "https://www.google.com/maps/dir/Current+Location/#{u(address)}"
  end
end
