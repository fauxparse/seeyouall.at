class ScheduledActivityPresenter < SimpleDelegator
  alias_method :scheduled_activity, :__getobj__

  delegate :name, :description, :photo_url, to: :activity
  delegate :start_time, :end_time, to: :time_slot

  def activity_type
    @activity_type ||= ActivityTypePresenter.new(scheduled_activity.activity.activity_type)
  end

  def activity
    ActivityPresenter.new(scheduled_activity.activity)
  end
  
  def date
    start_time.to_date
  end
  
  def room
    RoomPresenter.new(scheduled_activity.room) if room?
  end
  
  def room?
    scheduled_activity.room.present?
  end
  
  def self.model_name
    ScheduledActivity.model_name
  end
end
