class CreateActivity
  def initialize(event, params)
    @event = event
    @activity = @event.activities.build(params)
  end

  def call
    begin
      @activity.save!

    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def activity
    ActivityPresenter.new(@activity)
  end
end
