class ItinerariesController < ApplicationController
  wrap_parameters :itinerary, include: [:selections]
  before_action :ensure_registered, except: [:check]

  def show
  end

  def edit
    authorize!(:update, registration)
    @form = ItineraryForm.new(registration)

    respond_to do |format|
      format.html
      format.json { render json: @form }
    end
  end

  def update
    authorize!(:update, registration)
    @form = ItineraryForm.new(registration, itinerary_params)
    respond_to do |format|
      begin
        @form.save!
        format.html { redirect_to event_itinerary_path(event) }
        format.json { render json: @form }
      rescue ActiveRecord::RecordNotSaved
        format.html { render :edit }
        format.json { render json: @form, status: :unprocessable_entity }
      end
    end
  end

  def check
    form = ItineraryForm.new(registration, itinerary_params)
    form.validate
    render json: form
  end

  protected

  def ensure_registered
    registration
    redirect_to event_register_path(event) unless @registration.present?
  end

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
      registration = event.registrations.with_package.find_by(user_id: current_user.id)
      registration && RegistrationPresenter.new(registration)
    end
  end

  helper_method :event, :registration

  def itinerary_params
    params.require(:itinerary).permit(selections: [])
  end
end
