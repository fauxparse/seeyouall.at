class UpdateEvent
  def initialize(event, params)
    @form = EventForm.new(event, params)
  end

  def call
    @form.save
  end

  def event
    EventPresenter.new(@form.event)
  end
end
