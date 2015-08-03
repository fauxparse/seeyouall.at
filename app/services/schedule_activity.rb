class ScheduleActivity < Struct.new(:activity, :time_slot)
  def call
    raise ArgumentError unless activity.event.id == time_slot.event_id
    ScheduledActivity.find_or_create_by(activity_id: activity.id, time_slot_id: time_slot.id)
  end
end
