class CheckEventParams
  def initialize(params)
    @params = params
    @form = EventForm.new(Event.new, @params)
  end

  def call
    @form.validate
  end

  def event
    EventPresenter.new(@form.event)
  end
end
