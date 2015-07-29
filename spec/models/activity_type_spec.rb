require 'rails_helper'

RSpec.describe ActivityType, type: :model do
  subject(:activity_type) { FactoryGirl.build(:trial) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:event_id) }
  it { is_expected.to strip_spaces_from(:name) }
end
