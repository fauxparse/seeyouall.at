class PackagePresenter < SimpleDelegator
  alias_method :package, :__getobj__

  def description
    allocations.map(&:description).to_sentence
  end

  def allocations
    package.allocations.map { |a| AllocationPresenter.new(a) }
  end

  def limits
    allocations.map.with_object({}) do |allocation, limits|
      limits[allocation.activity_type_id] = allocation.maximum
    end
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

  def self.model_name
    Package.model_name
  end
end
