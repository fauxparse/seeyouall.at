class ItinerariesController < ApplicationController
  wrap_parameters :itinerary, include: [:selections]
  before_action :authenticate_user!
  before_action :ensure_registered, except: [:check]

  def show
    authorize!(:read, registration)
    @schedule = registration
      .selections
      .preload(:scheduled_activity => [:time_slot, { :activity => :activity_type }])
      .map { |selection| ScheduledActivityPresenter.new(selection.scheduled_activity) }
      .sort_by(&:start_time)
      .chunk(&:date)
      
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{event.slug}-#{current_user.name.to_url}",
          layout: true,
          disposition: "attachment",
          print_media_type: true,
          page_size: "A4",
          show_as_html: params[:debug].present? && Rails.env.development?
      end
    end
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
