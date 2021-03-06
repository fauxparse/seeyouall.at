class ActivityPresenter < SimpleDelegator
  alias_method :activity, :__getobj__

  def to_s
    name
  end

  def photo_url
    activity_photos.first.try(:url)
  end

  def self.model_name
    Activity.model_name
  end
end
