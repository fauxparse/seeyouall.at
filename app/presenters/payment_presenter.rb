class PaymentPresenter < SimpleDelegator
  alias_method :payment, :__getobj__

  def payment_method
    event.payment_methods.detect { |m| m.name == payment_method_name }
  end

  def event
    @event ||= EventPresenter.new(registration.event)
  end
end
