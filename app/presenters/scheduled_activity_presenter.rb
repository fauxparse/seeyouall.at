class ScheduledActivityPresenter < SimpleDelegator
  alias_method :scheduled_activity, :__getobj__

  delegate :name, :description, :photo_url, to: :activity

  def activity_type
    @activity_type ||= ActivityTypePresenter.new(scheduled_activity.activity.activity_type)
  end

  def activity
    ActivityPresenter.new(scheduled_activity.activity)
  end
end
