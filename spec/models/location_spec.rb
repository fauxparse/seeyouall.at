require 'rails_helper'

RSpec.describe Location, type: :model do
  subject(:location) { FactoryGirl.build(:location) }

  it { is_expected.to validate_presence_of(:address) }

  context "when created" do
    before { location.save! }

    describe "#latitude" do
      it "is generated automatically" do
        expect(location.latitude).to be_within(0.0001).of(-41.2935812)
      end
    end

    describe "#longitude" do
      it "is generated automatically" do
        expect(location.longitude).to be_within(0.0001).of(174.7845941)
      end
    end

    describe ".near" do
      it "finds locations" do
        expect(Location.near("Wellington")).to include(location)
      end
    end
  end
end
