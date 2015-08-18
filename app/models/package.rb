class Package < ActiveRecord::Base
  belongs_to :event, inverse_of: :packages
  has_many :allocations, inverse_of: :package, autosave: true, dependent: :destroy
  has_many :package_prices, inverse_of: :package, autosave: true, dependent: :destroy
  has_many :registrations, inverse_of: :package, autosave: true, dependent: :destroy

  auto_strip_attributes :name, squish: true

  validates :name, presence: { allow_blank: false }
end
