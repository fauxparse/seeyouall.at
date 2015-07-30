class Allocation < ActiveRecord::Base
  belongs_to :package, inverse_of: :allocations
  belongs_to :activity_type, inverse_of: :allocations

  validates :maximum,
    numericality: { greater_than: 0 },
    if: :maximum  # still fires if maximum.zero?
end
