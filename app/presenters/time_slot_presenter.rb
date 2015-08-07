class TimeSlotPresenter < SimpleDelegator
  alias_method :time_slot, :__getobj__

  def date
    start_time.to_date
  end

  def activity_types
    scheduled_activities.map { |s| s.activity.activity_type }.uniq
      .map { |t| ActivityTypePresenter.new(t) }
  end

  def activities_of_type(type)
    scheduled_activities.select { |s| s.activity.activity_type_id == type.id }
  end

  def empty?
    scheduled_activities.empty?
  end
end
