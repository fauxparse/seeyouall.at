class MapsController < ApplicationController
  def show
    authorize!(:read, event)
  end

  protected

  def event
    @event ||= EventPresenter.new(Event.with_locations.find_by!(slug: params[:event_id]))
  end

  helper_method :event
end
