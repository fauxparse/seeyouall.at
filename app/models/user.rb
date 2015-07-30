class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  has_many :registrations, inverse_of: :user, autosave: true, dependent: :destroy
  has_many :events, through: :registrations

  auto_strip_attributes :name, :email, squish: true

  validates :name, presence: { allow_blank: false }
end
