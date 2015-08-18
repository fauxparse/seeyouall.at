class ScheduleActivity
  attr_reader :activity, :time_slot

  def initialize(activity, time_slot, params)
    @activity = activity
    @time_slot = time_slot
    @params = params
  end

  def call
    raise ArgumentError unless activity.event.id == time_slot.event_id

    ScheduledActivity.transaction do
      @schedule = ScheduledActivity.find_or_create_by!(activity_id: activity.id, time_slot_id: time_slot.id)
      @schedule.update!(@params)
    end
  end

  def presenter
    @presenter ||= ScheduledActivityPresenter.new(@schedule)
  end
end
