class ApprovePayments
  attr_reader :event
  
  def initialize(event, payment_ids)
    @event = event
    @payment_ids = payment_ids
  end
  
  def call
    event.with_lock do
      payments.each { |payment| approve_payment(payment) unless payment.approved? }
    end
  end

  def payments
    @payments ||= @event.payments.preload(:registration => :user).find(@payment_ids)
  end
  
  def presented
    @presented ||= payments.map { |p| PaymentPresenter.new(p) }
  end
  
  private
  
  def approve_payment(payment)
    payment.approve!
    RegistrationMailer.payment_approval_email(payment).deliver_later
  end
end