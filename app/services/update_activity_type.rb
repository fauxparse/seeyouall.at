class UpdateActivityType
  def initialize(activity, params)
    @activity_type = activity_type
    @params = params
  end

  def call
    @activity_type.update(@params)
  end

  def activity_type
    ActivityTypePresenter.new(@activity_type)
  end
end
