class TimetableSerializer < ActiveModel::Serializer
  attributes :event_id, :start_date, :end_date, :time_zone, :time_slots,
    :activity_types, :activities, :scheduled_activities

  def event_id
    object.event.id
  end

  delegate :start_date, :end_date, to: :object

  def time_zone
    ActiveSupport::TimeZone[object.time_zone].tzinfo.name
  end

  def time_slots
    object.time_slots.map { |t| TimeSlotSerializer.new(t).attributes }
  end

  def activity_types
    object.activity_types.map { |t| ActivityTypeSerializer.new(t).attributes }
  end

  def activities
    object.activities.map { |a| ActivitySerializer.new(a).attributes }
  end

  def scheduled_activities
    object.scheduled_activities.map { |a| ScheduledActivitySerializer.new(a).attributes }
  end
end
