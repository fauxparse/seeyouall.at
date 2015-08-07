class Price < ActiveRecord::Base
  monetize :price_cents, as: :amount,
    numericality: { greater_than_or_equal_to: 0 }

  delegate :currency, to: :amount
end
