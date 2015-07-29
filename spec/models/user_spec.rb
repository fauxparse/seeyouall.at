require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.build(:hermione) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to strip_spaces_from(:name) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to strip_spaces_from(:email) }
end
