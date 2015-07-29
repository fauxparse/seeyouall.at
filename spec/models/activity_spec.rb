require 'rails_helper'

RSpec.describe Activity, type: :model do
  subject(:activity) { FactoryGirl.build(:activity) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to strip_spaces_from(:name) }
end
