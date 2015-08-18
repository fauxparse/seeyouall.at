class PaymentsController < ApplicationController
  before_action :ensure_registered, except: :index
  before_action :payment, only: [:new, :create]

  def index
  end

  def show
    render("payments/#{payment_method.name}/#{payment.state}")
  end

  def new
  end

  def create
    Payment.transaction do
      create_payment = CreatePayment.new(payment, payment_method)
        .on(:pending, :approved) { |payment| redirect_to(event_payment_path(event, payment)) }
        .on(:redirect) { |url| redirect_to(url) }
        .on(:failure) { logger.info(payment.errors.full_messages); render(:new) }
      create_payment.call
    end
  end

  protected

  def event
    @event ||= begin
      event = Event.with_payment_details.find_by!(slug: params[:event_id])
      EventPresenter.new(event)
    end
  end

  def registration
    return nil unless signed_in?

    @presenter ||= begin
      @registration = event.registrations.with_packages.with_payments
        .find_by(user_id: current_user.id)
      @registration && RegistrationPresenter.new(@registration)
    end
  end

  def ensure_registered
    redirect_to(event_register_path(event)) unless registration.present?
  end

  def payment
    @payment ||= @registration.payments.build(payment_params || {}).tap do |payment|
      payment.amount = registration.outstanding_balance if payment.amount.to_i.zero?
      payment.payment_method_name ||= event.payment_methods.first.name
    end
  end

  def payment_method
    event.payment_methods.detect { |m| m.name == payment.payment_method_name }
  end

  def payment_params
    params.require(:payment).permit(:payment_method_name) if params[:payment].present?
  end

  helper_method :event, :registration, :payment
end
