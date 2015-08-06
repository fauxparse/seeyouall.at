class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :activity_type_id, :name, :description
end
