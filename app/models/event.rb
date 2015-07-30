class Event < ActiveRecord::Base
  has_many :activity_types, dependent: :destroy, autosave: true
  has_many :activities, through: :activity_types
  has_many :time_slots, dependent: :destroy, autosave: true

  scope :upcoming, -> { where("start_time > ?", Time.current) }
  scope :current, -> {
    now = Time.current
    where("start_time <= ? AND end_time > ?", now, now)
  }
  scope :past, -> { where("end_time < ?", Time.current) }
  scope :in_chronological_order, -> { order(start_time: :asc) }

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
