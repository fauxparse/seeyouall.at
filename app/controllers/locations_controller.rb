class LocationsController < ApplicationController
  wrap_parameters :location, include: [:name, :address, :rooms]

  def index
    authorize!(:read, event)
    locations = event.locations.map { |location| present(location) }
    render(json: locations, serializer: LocationSerializer)
  end

  def create
    authorize!(:update, event)
    create = CreateLocation.new(event, location_params)
    create.call
    render(json: create.location, serializer: LocationSerializer)
  end

  def update
    authorize!(:update, event)
    location = event.locations.find(params[:id])
    update = UpdateLocation.new(location, location_params)
    update.call
    render(json: update.location, serializer: LocationSerializer)
  end

  def destroy
    authorize!(:update, event)
    location = event.locations.find(params[:id])
    location.destroy
    render(nothing: true)
  end

  protected

  def event
    @event ||= Event.with_locations.find_by!(slug: params[:event_id])
  end

  def location_params
    params.require(:location).permit(:name, :address, :rooms => [:id, :name])
  end

  def present(location)
    LocationPresenter.new(location)
  end
end
