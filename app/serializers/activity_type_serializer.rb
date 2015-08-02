class ActivityTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :plural

  delegate :name, :plural, to: :object
end
