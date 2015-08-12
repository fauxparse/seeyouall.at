class TimetablesController < ApplicationController
  def show
    @timetable = TimetablePresenter.new(event)

    respond_to do |format|
      format.html
      format.json { render(json: @timetable, serializer: TimetableSerializer)}
    end
  end

  def edit
    authorize!(:update, event)
    @timetable = TimetablePresenter.new(event)

    respond_to do |format|
      format.html
      format.json { render(json: @timetable, serializer: TimetableSerializer)}
    end
  end

  protected

  def event
    @event ||= Event
      .with_activities
      .with_schedule
      .with_locations
      .where(slug: params[:event_id])
      .first!
    @event_presenter ||= EventPresenter.new(@event)
  end

  helper_method :event
end
