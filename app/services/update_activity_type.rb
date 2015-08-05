class UpdateActivityType
  def initialize(activity, params)
    @activity_type = activity_type
    @params = params
  end

  def call
    begin
      @activity_type.update! @params
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def activity_type
    ActivityTypePresenter.new(@activity_type)
  end
end
