require 'rails_helper'

RSpec.describe Registration, type: :model do
  subject(:registration) { user.registrations.build(package: package, event: event) }
  let(:user) { FactoryGirl.create(:hermione) }
  let(:event) { FactoryGirl.create(:event) }
  let(:package) { FactoryGirl.create(:package, event: event) }

  context "already registered for the same event" do
    before { user.registrations.create(event: event, package: package) }

    it { is_expected.not_to be_valid }
  end
end
