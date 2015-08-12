class CreateActivity
  def initialize(event, params)
    @event = event
    @activity = @event.activities.build(params)
  end

  def call
    @activity.save
  end

  def activity
    ActivityPresenter.new(@activity)
  end
end
