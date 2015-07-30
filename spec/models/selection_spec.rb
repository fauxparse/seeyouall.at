require 'rails_helper'

RSpec.describe Selection, type: :model do
  subject(:selection) { registration.selections.build(scheduled_activity: scheduled_activity) }
  let(:registration) { user.registrations.create(package: package, event: event) }
  let(:user) { FactoryGirl.create(:hermione) }
  let(:event) { FactoryGirl.create(:event) }
  let(:package) { FactoryGirl.create(:package, event: event) }
  let(:activity) { FactoryGirl.create(:activity, activity_type: activity_type) }
  let(:activity_type) { FactoryGirl.create(:activity_type, event: event) }
  let(:scheduled_activity) { time_slot.scheduled_activities.create(activity: activity) }
  let(:time_slot) { FactoryGirl.create(:time_slot, event: event) }

  context "already selected the same scheduled activity" do
    before do
      registration.selections.create(scheduled_activity: scheduled_activity)
    end

    it { is_expected.not_to be_valid }
  end
end
