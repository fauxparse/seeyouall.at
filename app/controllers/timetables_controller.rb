class TimetablesController < ApplicationController
  def show
    @timetable = TimetablePresenter.new(event)

    respond_to do |format|
      format.html
      format.json { render(json: @timetable, serializer: TimetableSerializer)}
    end
  end

  def edit
    authorize! :update, event
    @timetable = TimetablePresenter.new(event)

    respond_to do |format|
      format.html
      format.json { render(json: @timetable, serializer: TimetableSerializer)}
    end
  end

  protected

  def event
    @event ||= Event
      .includes(
        :time_slots => :scheduled_activities,
        :activity_types => :activities
      )
      .where(slug: params[:event_id])
      .first!
  end
end