class Event < ActiveRecord::Base
  acts_as_url :name,
    url_attribute: :slug,
    only_when_blank: true,
    blacklist: %w(new)

  auto_strip_attributes :name, squish: true

  validates :name, presence: { allow_blank: false }
  validates :slug,
    presence: { allow_blank: false },
    uniqueness: true,
    format: { with: /[\w]+(-[\w]+)*/ }

  alias_method :to_param, :slug
end
