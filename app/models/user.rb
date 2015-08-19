class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable #, :confirmable

  has_many :registrations, inverse_of: :user, autosave: true, dependent: :destroy
  has_many :events, through: :registrations
  has_many :administrators, inverse_of: :user, dependent: :destroy
  has_many :facilitators, inverse_of: :activity, dependent: :destroy

  auto_strip_attributes :name, :email, squish: true

  serialize :options, JSON

  validates :name, presence: { allow_blank: false }

  def options=(new_options)
    options.merge!(new_options.stringify_keys)
  end
end
