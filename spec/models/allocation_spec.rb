require 'rails_helper'

RSpec.describe Allocation, type: :model do
  subject(:allocation) { Allocation.new }

  context "with no maximum" do
    it { is_expected.to be_valid }
  end

  context "with a maximum" do
    context "of 0" do
      before { allocation.maximum = 0 }
      it { is_expected.not_to be_valid }
    end

    context "of 5" do
      before { allocation.maximum = 5 }
      it { is_expected.to be_valid }
    end
  end
end
