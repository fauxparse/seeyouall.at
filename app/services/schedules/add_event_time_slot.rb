class AddEventTimeSlot < Struct.new(:event, :start_time, :end_time)
  def call
    event.time_slots.find_or_create_by!(
      start_time: start_time,
      end_time: end_time
    )
  end
end
