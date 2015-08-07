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
    package_prices.detect { |price| price.includes?(Time.current) }
  end

  def full_price
    package_prices.max(&:amount)
  end

  def package_prices
    package.package_prices.sort_by(&:start_time)
      .map { |p| PackagePricePresenter.new(p) }
  end
end
