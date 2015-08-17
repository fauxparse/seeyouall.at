class CheckEventParams
  def initialize(event, params)
    @event = event || Event.new
    @params = params
    @form = EventForm.new(event, @params)
  end

  def call
    @form.validate
  end

  def event
    EventPresenter.new(@form.event)
  end
end
