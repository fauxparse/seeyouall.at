require 'rails_helper'

RSpec.describe Price, type: :model do
  it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
end
