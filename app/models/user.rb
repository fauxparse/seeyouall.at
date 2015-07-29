class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  auto_strip_attributes :name, :email, squish: true

  validates :name, presence: { allow_blank: false }
end
