require "rails_helper"

describe AddUserAsEventAdministrator do
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event) }

  context "when the relationship does not exist" do
    it "creates the relationship" do
      expect { AddUserAsEventAdministrator.new(user, event).call }
        .to change { Administrator.count }.by(1)
    end
  end

  context "when the relationship already exists" do
    before do
      Administrator.create(user: user, event: event)
    end

    it "does not create the relationship again" do
      expect { AddUserAsEventAdministrator.new(user, event).call }
        .not_to change { Administrator.count }
    end
  end
end
