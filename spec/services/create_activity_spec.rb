require "rails_helper"

describe CreateActivity do
  subject(:create_activity) { CreateActivity.new(event, activity_params) }
  let(:activity_params) { {} }
  let(:type) { FactoryGirl.create(:activity_type) }
  let(:event) { type.event }

  describe "#call" do
    context "with valid parameters" do
      let(:activity_params) { { name: "A valid activity", activity_type_id: type.id } }

      it "returns true" do
        expect(create_activity.call).to be true
      end

      it "creates an activity" do
        expect { create_activity.call }.to change { event.activities.count }.by(1)
      end
    end

    context "with invalid parameters" do
      it "returns false" do
        expect(create_activity.call).to be false
      end

      it "does not create an activity" do
        expect { create_activity.call }.not_to change { event.activities.count }
      end
    end
  end
end
