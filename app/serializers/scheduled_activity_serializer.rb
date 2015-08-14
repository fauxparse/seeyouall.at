class ScheduledActivitySerializer < ActiveModel::Serializer
  attributes :id, :activity_id, :time_slot_id, :room_id
end
