class CreateEvent
  def initialize(params, user)
    @user = user
    @form = EventForm.new(Event.new, params)
  end

  def call
    begin
      Event.transaction do
        if @form.save!
          AddUserAsEventAdministrator.new(@user, @form.event).call
          CreateDefaultActivityType.new(@form.event).call
          CreateDefaultPackage.new(@form.event).call
        end
      end
      true

    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def event
    EventPresenter.new(@form.event)
  end
end
