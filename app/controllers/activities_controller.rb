class ActivitiesController < ApplicationController
  wrap_parameters :activity, include: [:activity_type_id, :name, :description, :photo_url]

  before_action :activity, only: [:update, :destroy]
  authorize_resource
  skip_authorize_resource only: [:create]

  def index
    authorize!(:update, event)
    @schedules = event.scheduled_activities
      .includes(:time_slot, room: :location, activity: :activity_type)
      .all
      .map { |s| ScheduledActivityPresenter.new(s) }
      .sort_by { |s| s.time_slot.start_time }
      .chunk { |s| s.time_slot.start_time.to_date }
  end

  def show
    authorize!(:update, event)
    activity = ScheduledActivity
      .includes(:time_slot, activity: :activity_type, selections: { registration: :user })
      .find(params[:id])
    @activity = ScheduledActivityPresenter.new(activity)
  end

  def create
    authorize!(:update, event)
    create_activity = CreateActivity.new(event, activity_params)
    call_and_respond_with create_activity
  end

  def update
    update_activity = UpdateActivity.new(activity, activity_params)
    call_and_respond_with update_activity
  end

  def destroy
    activity = event.activities.find(params[:id])
    authorize!(:destroy, activity)

    activity.destroy!

    respond_to do |format|
      format.html { redirect_to events_path }
      format.json { render nothing: true }
    end
  end

  protected

  def event
    @event ||= Event.find_by!(slug: params[:event_id])
  end

  def activity
    @activity ||= event.activities.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :activity_type_id, :photo_url)
  end

  def call_and_respond_with(service)
    result = service.call

    respond_to do |format|
      if result
        format.html { redirect_to(edit_event_activity_path(event, service.activity)) }
        format.json { render(json: service.activity, serializer: ActivitySerializer) }
      else
        format.html { render :edit }
        format.json { render(json: service.activity, serializer: ActivitySerializer, status: :unprocessable_entity) }
      end
    end
  end
end
