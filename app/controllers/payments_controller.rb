class PaymentsController < ApplicationController
  before_action :authenticate_user!, except: [:process_external_payment]
  before_action :ensure_registered, only: [:show, :new, :create]
  before_action :load_payment, only: [:show, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token, if: :processing_external_payment?

  def index
    authorize!(:update, event)
    @payment_methods = event.payment_methods.map.with_object({}) { |type, hash| hash[type.name] = type }
    @payments = ListPayments.new(event, params).call

    respond_to do |format|
      format.html
      format.json do
        render(json: @payments,
          serializer: PaginatedSerializer,
          each_serializer: PaymentSerializer,
          adapter: :json
        )
      end
    end
  end

  def show
    authorize!(:read, @payment)
    render("payments/#{@payment.payment_method_name}/#{@payment.state}")
  end

  def new
    registration.payments.select(&:pending?).map(&:destroy)
    @payment = blank_payment
  end

  def create
    Payment.transaction do
      @payment = blank_payment
      create_payment = CreatePayment.new(@payment, payment_method)
        .on(:pending, :approved) { |payment| redirect_to(event_payment_path(event, payment)) }
        .on(:redirect) { |url| redirect_to(url) }
        .on(:failure) { render(:new) }
      create_payment.call
    end
  end

  def approve
    authorize!(:update, event)
    approve = ApprovePayments.new(event, params[:payment_ids] || [])
    approve.call
    render(json: approve.payments, each_serializer: PaymentSerializer)
  end

  def decline
    authorize!(:update, event)
    decline = DeclinePayments.new(event, params[:payment_ids] || [])
    decline.call
    render(json: decline.payments, each_serializer: PaymentSerializer)
  end

  def process_external_payment
    ProcessExternalPayment.new(params.permit!).call
    render nothing: true
  end

  protected
  
  def processing_external_payment?
    (action_name == "process_external_payment") ||
    (request.post? && action_name == "show")
  end
  
  def load_payment
    @payment = event.payments.find(params[:id])
  end

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

  def payment_params
    params.require(:payment).permit(:payment_method_name) if params[:payment].present?
  end

  def blank_payment
    @registration.payments.build(payment_params || {}).tap do |payment|
      payment.amount = registration.outstanding_balance if payment.amount.to_i.zero?
      payment.payment_method_name ||= event.payment_methods.first.name
    end
  end
  
  def payment_method
    event.payment_methods.detect { |m| m.name == @payment.payment_method_name }
  end
  
  helper_method :event, :registration, :payment_method
end
