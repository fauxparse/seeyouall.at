class AccountsController < ApplicationController
  before_action :registration

  def show
  end

  protected

  def event
    @event ||= EventPresenter.new(Event.find_by!(slug: params[:event_id]))
  end

  def registration
    @registration ||= begin
      reg = event.registrations
        .with_payments
        .where(user_id: participant.id)
        .first
      redirect_to event_register_path(event) unless reg.present?
      RegistrationPresenter.new(reg)
    end
  end

  def participant
    UserPresenter.new(current_user)
  end

  helper_method :event, :registration, :participant
end
