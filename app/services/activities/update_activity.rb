class UpdateActivity
  def initialize(activity, params)
    @activity = activity
    @params = params
  end

  def call
    Activity.transaction do
      Rails.logger.info @params.inspect.yellow
      if url = @params.delete(:photo_url)
        photo.url = url
        photo.save
      end
      @activity.update(@params)
    end
  end

  def activity
    ActivityPresenter.new(@activity)
  end

  protected

  def photo
    @photo ||= begin
      activity_photo = @activity.activity_photos.first || @activity.activity_photos.build
      activity_photo.photo || activity_photo.build_photo
    end
  end
end
