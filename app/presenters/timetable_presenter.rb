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
    present_collection(event.activity_types, ActivityTypePresenter)
  end

  def activities
    present_collection(event.activities, ActivityPresenter)
  end

  def locations
    present_collection(event.locations, LocationPresenter)
  end

  def rooms
    present_collection(locations.map(&:rooms).flatten, RoomPresenter)
  end

  def self.model_name
    Event.model_name
  end

  protected

  def present_collection(collection, presenter)
    collection.map { |item| presenter.new(item) }.sort_by(&:to_s)
  end
end
