class ParticipantsController < ApplicationController
  before_action :load_event
  before_action :authorize_for_event_updates

  def index
    @participants = ListParticipants.new(@event, params).call
  end
  
  protected
  
  def load_event
    @event = Event.find_by!(slug: params[:event_id])
  end
  
  def authorize_for_event_updates
    authorize!(:update, @event)
  end
end
