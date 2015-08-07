require "rails_helper"

describe CreateEvent do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_params) { FactoryGirl.build(:event).as_json.with_indifferent_access }
  let(:invalid_params) { valid_params.merge(name: "") }

  context "with valid parameters" do
    subject(:service) { CreateEvent.new(valid_params, user) }

    it "returns true" do
      expect(service.call).to be true
    end

    it "creates an event" do
      expect { service.call }.to change { Event.count }.by(1)
    end

    it "adds the user as an administrator" do
      expect { service.call }.to change { Administrator.count }.by(1)
      expect(Administrator.where(user_id: user.id, event_id: service.event.id)).to exist
    end

    it "creates a default activity type for the new event" do
      service.call
      expect(service.event.activity_types).not_to be_empty
    end

    it "creates a default package for the new event" do
      service.call
      expect(service.event.packages).not_to be_empty
    end
  end

  context "with invalid parameters" do
    subject(:service) { CreateEvent.new(invalid_params, user) }

    it "returns false" do
      expect(service.call).to be false
    end

    it "does not create an event" do
      expect { service.call }.not_to change { Event.count }
    end

    it "does not add an administrator" do
      expect { service.call }.not_to change { Administrator.count }
    end
  end
end
