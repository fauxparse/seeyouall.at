require 'rails_helper'

RSpec.describe Selection, type: :model do
  subject(:selection) { registration.selections.build(scheduled_activity: scheduled_activity) }
  let(:registration) { FactoryGirl.create(:registration, event: scheduled_activity.activity.event) }
  let(:scheduled_activity) { FactoryGirl.create(:scheduled_activity) }

  it { is_expected.to be_valid }

  context "already selected the same scheduled activity" do
    before { registration.selections.create(scheduled_activity: scheduled_activity) }

    it { is_expected.not_to be_valid }
  end
end
