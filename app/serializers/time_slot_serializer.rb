class TimeSlotSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time

  def start_time
    object.start_time.iso8601
  end

  def end_time
    object.end_time.iso8601
  end
end
