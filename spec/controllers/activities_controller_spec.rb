require "rails_helper"

RSpec.describe ActivitiesController, type: :controller do
  include_context "logged in"

  let(:event) { FactoryGirl.create(:event) }
  let(:user) { FactoryGirl.create(:user).tap { |u| event.administrators.create!(user: u) } }
  let(:type) { FactoryGirl.create(:activity_type, event: event) }
  let(:activity_params) { FactoryGirl.build(:activity, activity_type_id: type.id).attributes }

  describe "POST #create" do
    before { post(:create, event_id: event.to_param, activity: activity_params) }
    it { is_expected.to redirect_to(edit_event_activity_path(event, Activity.first)) }

    it "creates an activity" do
      expect(Activity.count).to eq(1)
    end
  end
end
