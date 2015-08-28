class DeclinePayments
  attr_reader :event
  
  def initialize(event, payment_ids)
    @event = event
    @payment_ids = payment_ids
  end
  
  def call
    event.with_lock do
      payments.each { |payment| decline_payment(payment) unless payment.declined? }
    end
  end

  def payments
    @payments ||= @event.payments.preload(:registration => :user).find(@payment_ids)
  end
  
  def presented
    @presented ||= payments.map { |p| PaymentPresenter.new(p) }
  end
  
  private
  
  def decline_payment(payment)
    payment.decline!
  end
end