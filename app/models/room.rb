class Room < ActiveRecord::Base
  has_many :scheduled_activities, inverse_of: :room, dependent: :nullify
  belongs_to :location, inverse_of: :rooms
end
