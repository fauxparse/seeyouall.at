class UpdateActivity
  def initialize(activity, params)
    @activity = activity
    @params = params
  end

  def call
    @activity.update(@params)
  end

  def activity
    ActivityPresenter.new(@activity)
  end
end
