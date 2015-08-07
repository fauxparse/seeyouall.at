class RegistrationsController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]

  def show
    redirect_to event_register_path(event) unless can? :read, registration
  end

  def new
    @registration = RegistrationForm.new(event, current_user)
    redirect_to event_registration_path(event) unless @registration.new_record?
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
      .includes(:packages => { :allocations => :activity_type, :package_prices => :price })
      .where(slug: params[:event_id])
      .first!
    @event_presenter ||= EventPresenter.new(@event)
  end

  def registration
    @registration ||= begin
      scope = event.registrations.with_package_information

      registration = if params[:id].present?
        scope.find(params[:id])
      else
        scope.find_by!(user_id: current_user.id)
      end

      RegistrationPresenter.new(registration)
    end
  end

  helper_method :event, :registration
end
