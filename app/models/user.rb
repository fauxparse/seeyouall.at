class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  validates :name, presence: { allow_blank: false }
end
