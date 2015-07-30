class Payment < ActiveRecord::Base
  belongs_to :registration, inverse_of: :payments

  enum state: [:pending, :approved, :declined, :refunded]

  validates :amount,
    presence: { allow_blank: false },
    numericality: { greater_than: 0 }
end
