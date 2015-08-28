class PaymentPresenter < SimpleDelegator
  alias_method :payment, :__getobj__
  
  delegate :name, :email, to: :user

  def payment_method
    @payment_method ||= event.payment_methods.detect { |m| m.name == payment.payment_method_name }
  end

  def payment_method_description
    I18n.t("payment_methods.#{payment_method.name}.name")
  end

  def event
    @event ||= EventPresenter.new(registration.event)
  end

  def user
    @user ||= UserPresenter.new(registration.user)
  end
  
  def amount
    @amount ||= MoneyPresenter.new(payment.amount)
  end

  def currency
    payment.amount.currency
  end

  def date
    updated_at.to_date
  end
end
