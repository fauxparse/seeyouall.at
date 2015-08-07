class ItinerariesController < ApplicationController
  def show
  end

  def edit
  end

  protected

  def event
    @event ||= begin
      event = Event
        .with_schedule
        .where(slug: params[:event_id])
        .first!
      EventPresenter.new(event)
    end
  end

  def registration
    @registration ||= begin
      registration = event.registrations.with_package.find_by!(user_id: current_user.id)
      RegistrationPresenter.new(registration)
    end
  end

  helper_method :event, :registration
end
