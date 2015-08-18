class CreateLocation
  def initialize(event, params = {})
    @event = event
    @params = params
  end

  def call
    Location.transaction do
      @location = @event.locations.create!(@params)
      @location.rooms.create!(name: @location.name)
    end
  end

  def location
    @presenter ||= LocationPresenter.new(@location)
  end
end
