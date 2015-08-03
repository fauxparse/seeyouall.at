class TimeSlotsController < ApplicationController
  def create
    authorize! :update, event
    params = time_slot_params
    add_event_time_slot = AddEventTimeSlot.new(event, params[:start_time], params[:end_time])
    @time_slot = add_event_time_slot.call
    render(json: TimeSlotPresenter.new(@time_slot), serializer: TimeSlotSerializer)
  end

  def destroy
    authorize! :update, event
    time_slot = event.time_slots.find(params[:id])
    time_slot.destroy
    render(nothing: true)
  end

  protected

  def event
    @event ||= Event.find_by!(slug: params[:event_id])
  end

  def time_slot_params
    params.require(:time_slot).permit(:start_time, :end_time)
  end
end
