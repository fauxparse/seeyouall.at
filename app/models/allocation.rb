class Allocation < ActiveRecord::Base
  belongs_to :package, inverse_of: :allocations
  belongs_to :activity_type, inverse_of: :allocations
  has_many :individual_activity_prices, inverse_of: :allocation, dependent: :destroy

  validates :maximum,
    numericality: { greater_than: 0 },
    if: :maximum  # still fires if maximum.zero?
end
