class PackagePricePresenter < SimpleDelegator
  alias_method :package_price, :__getobj__

  def includes?(time)
    start_time <= time && time < end_time
  end

  def amount
    price.amount
  end

  def start_date
    start_time.to_date
  end

  def end_date
    end_time.to_date
  end

  def self.model_name
    PackagePrice.model_name
  end
end
