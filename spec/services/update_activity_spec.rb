require "rails_helper"

describe UpdateActivity do
  subject(:update) { UpdateActivity.new(activity, params) }
  let(:activity) { FactoryGirl.create(:activity) }

  describe "#call" do
    context "with valid parameters" do
      let(:params) { { name: "Updated" } }

      it "returns true" do
        expect(update.call).to be true
      end

      it "updates the activity" do
        expect { update.call }.to change { activity.reload.name }
      end
    end

    context "with invalid parameters" do
      let(:params) { { name: nil } }

      it "returns false" do
        expect(update.call).to be false
      end

      it "does not update the activity" do
        expect { update.call }.not_to change { activity.reload.name }
      end

      it "has errors" do
        update.call
        expect(update.activity).to have(1).error_on(:name)
      end
    end
  end
end
