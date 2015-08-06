class PackagePresenter < SimpleDelegator
  alias_method :package, :__getobj__

  def description
    allocations.map(&:description).to_sentence
  end

  def allocations
    package.allocations.map { |a| AllocationPresenter.new(a) }
  end

  def available?
    current_price.present?
  end

  def current_price
    package_prices.detect do |price|
      price.start_time <= Time.current &&
        Time.current < price.end_time
    end
  end
end
