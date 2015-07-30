class IndividualActivityPrice < ActiveRecord::Base
  belongs_to :allocation, inverse_of: :individual_activity_prices
  belongs_to :price
end
