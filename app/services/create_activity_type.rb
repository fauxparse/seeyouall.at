class CreateActivityType
  def initialize(event, params)
    @event = event
    @activity_type = @event.activity_types.build(params)
  end

  def call
    begin
      @activity_type.save!

    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def activity_type
    ActivityTypePresenter.new(@activity_type)
  end
end
