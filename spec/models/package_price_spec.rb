require 'rails_helper'

RSpec.describe PackagePrice, type: :model do
  subject(:package_price) { PackagePrice.new(start_time: Time.now) }

  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }

  describe "#end_time" do
    it "cannot be before #start_time" do
      package_price.end_time = package_price.start_time - 1.hour
      expect(package_price).not_to be_valid
    end
  end
end
