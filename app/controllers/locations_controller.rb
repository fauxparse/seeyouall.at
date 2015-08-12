class LocationsController < ApplicationController
  def index
    authorize!(:read, event)
    locations = event.locations.map { |location| present(location) }
    render(json: locations, serializer: LocationSerializer)
  end

  def create
    authorize!(:update, event)
    location = present(event.location.create!(location_params))
    render(json: location, serializer: LocationSerializer)
  end

  protected

  def event
    @event ||= Event.find_by!(params[:event_id])
  end

  def location_params
    params.require(:location).permit(:name, :address)
  end

  def present(location)
    LocationPresenter.new(location)
  end
end
