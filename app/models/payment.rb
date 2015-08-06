class Payment < ActiveRecord::Base
  belongs_to :registration, inverse_of: :payments

  enum state: [:pending, :approved, :declined, :refunded]

  monetize :amount_cents, numericality: { greater_than: 0 }
end
