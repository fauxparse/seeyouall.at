class Facilitator < ActiveRecord::Base
  belongs_to :activity, inverse_of: :facilitators
  belongs_to :user, inverse_of: :facilitators

  auto_strip_attributes :name, :email, squish: true, nullify: true

  validates :name, :email,
    presence: { allow_blank: false },
    unless: :user_id?
end
