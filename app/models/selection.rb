class Selection < ActiveRecord::Base
  belongs_to :registration, inverse_of: :selections
  belongs_to :scheduled_activity, inverse_of: :selections, counter_cache: true
  has_one :time_slot, through: :scheduled_activity
  has_one :activity, through: :scheduled_activity

  validates :scheduled_activity_id, uniqueness: { scope: :registration_id }
end
