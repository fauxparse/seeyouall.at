require 'rails_helper'

RSpec.describe Package, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to strip_spaces_from(:name) }
end
