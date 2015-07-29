require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { FactoryGirl.build(:tri_wizard) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to strip_spaces_from(:name) }

  describe "#slug" do
    it "contains only valid characters" do
      event.slug = "!@#$%"
      expect(event).not_to be_valid
      expect(event).to have(1).error_on(:slug)
    end

    it "is automatically generated" do
      event.slug = nil
      expect(event).to be_valid
      expect(event.slug).to eq("tri-wizard-tournament")
    end

    it "fixes slugs in the blacklist automatically" do
      event.slug = "new"
      expect(event).to be_valid
      expect(event.slug).to eq("new-event")
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      event.save!
      expect(event.to_param).to eq("tri-wizard-tournament")
    end
  end
end
