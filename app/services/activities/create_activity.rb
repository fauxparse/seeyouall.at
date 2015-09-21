class CreateActivity
  def initialize(event, params)
    @event = event
    @params = params
  end

  def call
    Activity.transaction do
      photo_url = @params.delete(:photo_url)
      @activity = @event.activities.build(@params)
      add_photo(photo_url) if photo_url.present?
      @activity.save
    end
  end

  def activity
    ActivityPresenter.new(@activity)
  end

  private

  def add_photo(photo_url)
    @activity.activity_photos.build(photo: Photo.create(url: photo_url))
  end
end
