class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :start_date, :end_date, :errors

  def start_date
    object.start_date
  end

  def end_date
    object.end_date
  end

  def errors
    object.errors
  end
end
