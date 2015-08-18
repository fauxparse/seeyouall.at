require "rails_helper"

describe UpdateEvent do
  let(:event) { FactoryGirl.create(:tri_wizard) }
  let(:valid_params) { event.as_json.with_indifferent_access.merge(name: "Updated") }
  let(:invalid_params) { valid_params.merge(name: "") }

  context "with valid parameters" do
    subject(:service) { UpdateEvent.new(event, valid_params) }

    it "returns true" do
      expect(service.call).to be true
    end

    it "updates the event" do
      service.call
      expect(event.reload.name).to eq("Updated")
    end
  end

  context "with invalid parameters" do
    subject(:service) { UpdateEvent.new(event, invalid_params) }

    it "returns false" do
      expect(service.call).to be false
    end

    it "does not update the event" do
      expect(event.reload.name).to eq("Tri-Wizard Tournament")
    end
  end
end
