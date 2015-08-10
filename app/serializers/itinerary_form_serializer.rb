class ItineraryFormSerializer < ActiveModel::Serializer
  attributes :selections, :limits, :schedule, :errors

  def selections
    object.schedules.map(&:id)
  end

  def schedule
    object.schedule
  end

  def limits
    counts = object.counts_by_activity_type
    limits = object.package.limits

    object.event.activity_types.map.with_object({}) do |type, hash|
      if limits[type.id]
        hash[type.id] = {
          count: counts[type.id] || 0,
          limit: limits[type.id]
        }
      end
    end
  end

  def errors
    object.errors
  end
end
