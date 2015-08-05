class ActivityTypesController < ApplicationController
  def create
    authorize! :update, event
    create_activity_type = CreateActivityType.new(event, activity_type_params)

    respond_to do |format|
      if create_activity_type.call
        format.html { redirect_to(edit_event_activity_type_path(event, create_activity_type.activity_type)) }
        format.json { render(json: create_activity_type.activity_type, serializer: ActivityTypeSerializer) }
      else
        format.html { render :new }
        format.json { render(json: create_activity_type.activity_type, serializer: ActivityTypeSerializer, status: :unprocessable_entity) }
      end
    end
  end

  def update
    activity_type = event.activity_types.find(params[:id])
    authorize! :update, activity_type
    update_activity_type = update_activity_type.new(activity_type, activity_type_params)

    respond_to do |format|
      if update_activity_type.call
        format.html { redirect_to(edit_event_activity_type_path(event, update_activity_type.activity_type)) }
        format.json { render(json: update_activity_type.activity_type, serializer: ActivityTypeSerializer) }
      else
        format.html { render :edit }
        format.json { render(json: update_activity_type.activity_type, serializer: ActivityTypeSerializer, status: :unprocessable_entity) }
      end
    end
  end

  def destroy
    activity_type = event.activity_types.find(params[:id])
    authorize! :destroy, activity_type

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

  def activity_type_params
    params.require(:activity_type).permit(:name, :color_name)
  end
end
