class RegistrationPresenter < SimpleDelegator
  alias_method :registration, :__getobj__

  def outstanding_balance
    balance = total - total_paid
    balance < 0 ? Money.new(0, currency) : balance
  end

  def paid?
    outstanding_balance <= 0
  end

  def total
    package_price.amount
  end

  def subtotal
    total
  end

  def full_price
    package_prices.sort_by(&:amount).last.amount
  end

  def discounted?
    subtotal < full_price
  end

  def total_paid
    Money.new(payments.select(&:approved?).sum(&:amount), currency)
  end

  def package
    @package ||= PackagePresenter.new(registration.package)
  end

  def package_prices
    @package_prices ||= registration.package.package_prices.sort_by(&:start_time)
      .map { |p| PackagePricePresenter.new(p) }
  end

  def package_price
    first_payment_package_price || current_package_price || package_prices.last
  end

  def currency
    package_prices.first.price.currency
  end

  def event
    @event ||= EventPresenter.new(registration.event)
  end

  protected

  def current_package_price
    first_package_price_where { |range| range.includes?(Time.current) }
  end

  def first_payment_package_price
    first_package_price_where { |range| paid_at_least_deposit_during?(range) }
  end

  def first_package_price_where(&block)
    package_prices.select(&block).sort_by(&:amount).first
  end

  def paid_at_least_deposit_during?(range)
    payments.any? { |p| p.approved? && range.includes?(p.updated_at) }
  end
end
