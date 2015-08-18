class EventsController < ApplicationController
  wrap_parameters :event, include: EventForm.wrapped_parameters

  before_action :authenticate_user!, except: [:index, :show]
  before_action :event, only: [:show, :edit, :update, :destroy]

  authorize_resource
  skip_load_and_authorize_resource only: [:index, :check]

  def index
    events = Event.current_and_upcoming.in_chronological_order.limit(5)
    @events = events.map { |e| EventPresenter.new(e) }

    respond_to do |format|
      format.html
      format.json { render json: @events, serializer: EventSerializer }
    end
  end

  def show
    respond_to do |format|
      @event = EventPresenter.new(event)
      format.html
      format.json { render json: @event, serializer: EventSerializer }
    end
  end

  def new
    @event = EventPresenter.new(Event.new)
  end

  def create
    create_event = CreateEvent.new(event_params, current_user)
    call_and_respond_with create_event
  end

  def edit
    @event = EventPresenter.new(event)
  end

  def update
    update_event = UpdateEvent.new(event, event_params)
    call_and_respond_with update_event
  end

  def destroy
    event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path }
      format.json { render nothing: true }
    end
  end

  def check
    check_event_params = CheckEventParams.new(event, event_params)
    check_event_params.call
    render(json: check_event_params.event, serializer: EventSerializer)
  end

  private

  def event_params
    params.require(:event).permit(EventForm.permitted_parameters)
  end

  def event
    @event ||= params[:id] && Event.find_by!(slug: params[:id])
  end

  def registration
    @registration ||= begin
      registration = event && current_user && current_user.registrations.for_event(event).first
      registration && RegistrationPresenter.new(registration)
    end
  end

  helper_method :event, :registration

  def call_and_respond_with(service)
    result = service.call

    respond_to do |format|
      @event = service.event

      if result
        format.html { redirect_to(edit_event_path(@event)) }
        format.json { render(json: @event, serializer: EventSerializer) }
      else
        format.html { render(@event.new_record? ? :new : :edit) }
        format.json { render(json: @event, serializer: EventSerializer, status: :unprocessable_entity) }
      end
    end
  end
end
