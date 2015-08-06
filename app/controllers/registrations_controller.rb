class RegistrationsController < ApplicationController
  def show

  end

  def new
    @registration = RegistrationForm.new(event, current_user)
  end

  def create
    @registration = RegistrationForm.new(event, current_user, params)

    respond_to do |format|
      if @registration.save
        sign_in(@registration.user.user)
        format.html { redirect_to event_registration_path(@registration.event) }
      else
        format.html { render :new }
      end
    end
  end

  protected

  def event
    @event ||= Event
      .includes(:packages => { :allocations => :activity_type })
      .where(slug: params[:event_id])
      .first!
    @event_presenter ||= EventPresenter.new(@event)
  end

  helper_method :event
end
