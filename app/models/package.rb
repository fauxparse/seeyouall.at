class Package < ActiveRecord::Base
  belongs_to :event

  auto_strip_attributes :name, squish: true

  validates :name, presence: { allow_blanks: false }
end
