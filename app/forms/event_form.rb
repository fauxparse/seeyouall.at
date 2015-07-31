class EventForm < SimpleDelegator
  def initialize(event = nil, params = {})
    super event || Event.new

    params.each_pair do |key, value|
      self.public_send :"#{key}=", value
    end
  end

  def event
    __getobj__
  end

  def present
    EventPresenter.new(self)
  end

  def start_date=(value)
    event.start_time = value.presence && Time.zone.parse(value.to_s)
  end

  def end_date=(value)
    event.end_time = value.presence && Time.zone.parse(value.to_s).end_of_day
  end

  def self.permitted_parameters
    [:name, :slug, :start_date, :end_date]
  end

  def self.wrapped_parameters
    permitted_parameters.flat_map do |param|
      param.try(:keys) || param
    end
  end
end
