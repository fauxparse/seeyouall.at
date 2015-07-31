class UpdateEvent
  def initialize(event, params)
    @form = EventForm.new(event, params)
  end

  def call
    begin
      @form.save!
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def event
    EventPresenter.new(@form.event)
  end
end
