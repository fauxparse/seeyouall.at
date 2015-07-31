require 'rails_helper'

RSpec.describe Facilitator, type: :model do
  subject(:facilitator) { FactoryGirl.build(:facilitator) }

  context "without an associated user" do
    it { is_expected.to be_valid }
  end

  context "with an associated user" do
    before { facilitator.user = FactoryGirl.create(:user) }

    it { is_expected.to be_valid }
  end
end
