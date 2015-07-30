class Selection < ActiveRecord::Base
  belongs_to :registration, inverse_of: :selections
  belongs_to :scheduled_activity, inverse_of: :selections

  validates :scheduled_activity_id, uniqueness: { scope: :registration_id }
end
