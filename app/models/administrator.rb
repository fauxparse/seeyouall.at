class Administrator < ActiveRecord::Base
  belongs_to :user, inverse_of: :administrators
  belongs_to :event, inverse_of: :administrators
end
