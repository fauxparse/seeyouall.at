class CreateActivityType
  def initialize(event, params)
    @event = event
    @activity_type = @event.activity_types.build(params)
  end

  def call
    @activity_type.save
  end

  def activity_type
    ActivityTypePresenter.new(@activity_type)
  end
end
