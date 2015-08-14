class ScheduledActivitiesController < ApplicationController
  def create
    authorize!(:update, event)
    scheduled_activity = ScheduleActivity.new(activity, time_slot).call
    render(json: ScheduledActivityPresenter.new(scheduled_activity), serializer: ScheduledActivitySerializer)
  end

  def update
    authorize!(:update, event)
    scheduled_activity = event.scheduled_activities.find(params[:id])
    scheduled_activity.update!(scheduled_activity_params)
    render(json: ScheduledActivityPresenter.new(scheduled_activity), serializer: ScheduledActivitySerializer)
  end

  def destroy
    authorize!(:update, event)
    scheduled_activity = event.scheduled_activities.find(params[:id])
    scheduled_activity.destroy
    render(nothing: true)
  end

  protected

  def event
    @event ||= Event.find_by!(slug: params[:event_id])
  end

  def activity
    @activity ||= event.activities.find(scheduled_activity_params[:activity_id])
  end

  def time_slot
    @time_slot ||= event.time_slots.find(scheduled_activity_params[:time_slot_id])
  end

  def scheduled_activity_params
    params.require(:scheduled_activity).permit(:activity_id, :time_slot_id, :room_id)
  end
end
