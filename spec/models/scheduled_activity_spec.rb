require 'rails_helper'

RSpec.describe ScheduledActivity, type: :model do
  subject(:scheduled_activity) { ScheduledActivity.new(activity: activity, time_slot: time_slot) }

  let(:event) { FactoryGirl.create(:event) }
  let(:activity_type) { FactoryGirl.create(:activity_type, event: event) }
  let(:activity) { FactoryGirl.create(:activity, activity_type: activity_type) }
  let(:time_slot) { FactoryGirl.create(:time_slot, event: event) }
  let(:location) { FactoryGirl.create(:location) }

  context "without a location" do
    it { is_expected.to be_valid }
  end

  context "with a location" do
    before do
      scheduled_activity.location = location
    end

    it { is_expected.to be_valid }
  end
end
