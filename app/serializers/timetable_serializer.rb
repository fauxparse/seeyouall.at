class TimetableSerializer < ActiveModel::Serializer
  attributes :event_id, :event_slug, :start_date, :end_date, :time_zone, :time_slots,
    :activity_types, :activities, :scheduled_activities, :locations

  def event_id
    object.event.id
  end

  def event_slug
    object.event.slug
  end

  delegate :start_date, :end_date, to: :object

  def time_zone
    ActiveSupport::TimeZone[object.time_zone].tzinfo.name
  end

  def time_slots
    serialize_all(:time_slots, TimeSlotSerializer)
  end

  def activity_types
    serialize_all(:activity_types, ActivityTypeSerializer)
  end

  def activities
    serialize_all(:activities, ActivitySerializer)
  end

  def scheduled_activities
    serialize_all(:scheduled_activities, ScheduledActivitySerializer)
  end

  def locations
    serialize_all(:locations, LocationSerializer)
  end

  private

  def serialize_all(name, serializer)
    object.public_send(name).map { |item| serializer.new(item).attributes }
  end
end
