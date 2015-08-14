class Event < ActiveRecord::Base
  has_many :activity_types, inverse_of: :event, dependent: :destroy, autosave: true
  has_many :activities, through: :activity_types
  has_many :time_slots, inverse_of: :event, dependent: :destroy, autosave: true
  has_many :scheduled_activities, through: :time_slots
  has_many :packages, inverse_of: :event, dependent: :destroy, autosave: true
  has_many :registrations, inverse_of: :event, autosave: true, dependent: :destroy
  has_many :administrators, inverse_of: :event, autosave: true, dependent: :destroy
  has_many :locations, inverse_of: :event, autosave: true, dependent: :destroy

  scope :upcoming, -> { where("start_time > ?", Time.current) }
  scope :current, -> {
    now = Time.current
    where("start_time <= ? AND end_time > ?", now, now)
  }
  scope :past, -> { where("end_time < ?", Time.current) }
  scope :current_and_upcoming, -> { where("end_time > ?", Time.current) }
  scope :in_chronological_order, -> { order(start_time: :asc) }
  scope :with_activities, -> { includes(:activity_types => :activities) }
  scope :with_schedule, -> { includes(:scheduled_activities => [:time_slot, { :activity => :activity_type }]) }
  scope :with_packages, -> { includes(:packages => { :allocations => :activity_type, :package_prices => :price }) }
  scope :with_locations, -> { includes(:locations => :rooms) }

  acts_as_url :name,
    url_attribute: :slug,
    only_when_blank: true,
    blacklist: %w(new)

  auto_strip_attributes :name, squish: true

  validates :name, :time_zone,
    presence: { allow_blank: false }
  validates :slug,
    presence: { allow_blank: false },
    uniqueness: true,
    format: { with: /[\w]+(-[\w]+)*/ }
  validates :start_time, :end_time,
    presence: { allow_blank: false }
  validates_with TimePeriodValidator

  alias_method :to_param, :slug
end
