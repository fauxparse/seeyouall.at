require 'rails_helper'

RSpec.describe Registration, type: :model do
  subject(:registration) { user.registrations.build(package: package, event: event) }
  let(:user) { FactoryGirl.create(:hermione) }
  let(:event) { FactoryGirl.create(:event) }
  let(:package) { FactoryGirl.create(:package, event: event) }

  context "already registered for the same event" do
    before do
      user.registrations.create(event: event, package: package)
    end

    it "is invalid" do
      expect(registration).not_to be_valid
    end
  end
end
