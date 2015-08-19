class Payment < ActiveRecord::Base
  belongs_to :registration, inverse_of: :payments

  enum state: [:pending, :approved, :declined, :refunded]

  monetize :amount_cents, numericality: { greater_than: 0 }

  scope :paid, -> { where(state: :approved) }
  scope :for_event, ->(event) {
    includes(:registration => :user)
      .where("registrations.event_id = ?", event.id)
      .references(:registrations)
  }

  def payment_method
    PaymentMethod.payment_method_instance(payment_method_name)
  end

  def payment_method=(payment_method)
    self.payment_method_name = payment_method.class.name.demodulize.underscore
  end
end
