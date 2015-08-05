class ActivityTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :plural, :color_name

  delegate :name, :plural, to: :object
end
