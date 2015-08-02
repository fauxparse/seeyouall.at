class TimetablePresenter < SimpleDelegator
  def initialize(event)
    event = EventPresenter.new(event) unless event.instance_of? EventPresenter
    super(event)
  end

  def event
    __getobj__
  end

  def time_slots
    event.time_slots.sort_by(&:start_time).map { |t| TimeSlotPresenter.new(t) }
  end

  def time_slots_by_day
    time_slots
      .sort_by(&:start_time)
      .chunk { |time_slot| time_slot.start_time.to_date }
  end

  def activity_types
    event.activity_types.map { |t| ActivityTypePresenter.new(t) }.sort_by(&:to_s)
  end

  def activities
    event.activities.map { |a| ActivityPresenter.new(a) }.sort_by(&:to_s)
  end
end
