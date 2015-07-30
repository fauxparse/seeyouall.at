class Registration < ActiveRecord::Base
  belongs_to :user, inverse_of: :registrations
  belongs_to :event, inverse_of: :registrations
  belongs_to :package, inverse_of: :registrations

  validates :user_id, uniqueness: { scope: :event_id }
end
