class Registration < ActiveRecord::Base
  belongs_to :user, inverse_of: :registrations
  belongs_to :event, inverse_of: :registrations
  belongs_to :package, inverse_of: :registrations
  has_many :selections, inverse_of: :registration, dependent: :destroy
  has_many :payments, inverse_of: :registration, dependent: :destroy

  scope :with_package, -> { includes(
    { :package => { :allocations => :activity_type } },
    # :selections
  ) }
  scope :with_packages, -> { includes(
    :package => [{ :package_prices => :price, :allocations => :activity_type }]
  ) }
  scope :with_payments, -> { includes(:payments) }

  validates :user_id, uniqueness: { scope: :event_id }
  validates :package_id, presence: { allow_blank: false }
  validates_associated :user
end
