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

  before_validation :generate_token

  validates :payment_method_name, :token,
    presence: { allow_blank: false }

  def payment_method
    registration.event.payment_method(payment_method_name)
  end

  def payment_method=(payment_method)
    self.payment_method_name = payment_method.class.name.demodulize.underscore
  end

  protected

  def generate_token
    loop do
      self.token = SecureRandom.hex(32)
      break unless self.class.exists? token: token
    end
  end
end
