class ActivitiesController < ApplicationController
  def create
    authorize! :update, event
    create_activity = CreateActivity.new(event, activity_params)

    respond_to do |format|
      if create_activity.call
        format.html { redirect_to(edit_event_activity_path(event, create_activity.activity)) }
        format.json { render(json: create_activity.activity, serializer: ActivitySerializer) }
      else
        format.html { render :new }
        format.json { render(json: create_activity.activity, serializer: ActivitySerializer, status: :unprocessable_entity) }
      end
    end
  end

  def update
    activity = event.activities.find(params[:id])
    authorize! :update, activity
    update_activity = UpdateActivity.new(activity, activity_params)

    respond_to do |format|
      if update_activity.call
        format.html { redirect_to(edit_event_activity_path(event, update_activity.activity)) }
        format.json { render(json: update_activity.activity, serializer: ActivitySerializer) }
      else
        format.html { render :edit }
        format.json { render(json: update_activity.activity, serializer: ActivitySerializer, status: :unprocessable_entity) }
      end
    end
  end

  def destroy
    activity = event.activities.find(params[:id])
    authorize! :destroy, activity

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

  def activity_params
    params.require(:activity).permit(:name, :description, :activity_type_id)
  end
end
