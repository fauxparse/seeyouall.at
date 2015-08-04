class UpdateActivity
  def initialize(activity, params)
    @activity = activity
    @params = params
  end

  def call
    begin
      @activity.update! @params
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def activity
    ActivityPresenter.new(@activity)
  end
end
