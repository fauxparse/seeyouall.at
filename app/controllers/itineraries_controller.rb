class ItinerariesController < ApplicationController
  wrap_parameters :itinerary, include: [:selections]

  def show
  end

  def edit
    @form = ItineraryForm.new(registration)

    respond_to do |format|
      format.html
      format.json { render json: @form }
    end
  end

  def check
    form = ItineraryForm.new(registration, itinerary_params)
    form.validate
    render json: form
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

  def itinerary_params
    params.require(:itinerary).permit(selections: [])
  end
end
