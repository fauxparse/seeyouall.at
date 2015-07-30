class PackagePrice < ActiveRecord::Base
  belongs_to :package, inverse_of: :package_prices
  belongs_to :price

  validates :start_time, :end_time, presence: true
  validates_with TimePeriodValidator
end
