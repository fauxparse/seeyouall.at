class ActivityTypesController < ApplicationController
  before_filter :activity_type, only: [:update, :destroy]
  authorize_resource
  skip_authorize_resource only: [:create]

  def create
    authorize!(:update, event)
    create_activity_type = CreateActivityType.new(event, activity_type_params)

    respond_to do |format|
      call_and_respond_with create_activity_type
    end
  end

  def update
    update_activity_type = update_activity_type.new(activity_type, activity_type_params)

    respond_to do |format|
      call_and_respond_with update_activity_type
    end
  end

  def destroy
    activity_type.destroy!

    respond_to do |format|
      format.html { redirect_to events_path }
      format.json { render nothing: true }
    end
  end

  protected

  def event
    @event ||= Event.find_by!(slug: params[:event_id])
  end

  def activity_type
    @activity_type ||= event.activity_types.find(params[:id])
  end

  def activity_type_params
    params.require(:activity_type).permit(:name, :color_name)
  end

  def call_and_respond_with(service)
    result = service.call

    respond_to do |format|
      if result
        format.html { redirect_to(edit_event_activity_type_path(event, service.activity_type)) }
        format.json { render(json: service.activity_type, serializer: ActivityTypeSerializer) }
      else
        format.html { render :edit }
        format.json { render(json: service.activity_type, serializer: ActivityTypeSerializer, status: :unprocessable_entity) }
      end
    end
  end
end
