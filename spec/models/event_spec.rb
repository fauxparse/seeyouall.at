require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { FactoryGirl.build(:tri_wizard) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to strip_spaces_from(:name) }

  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }
  it { is_expected.to validate_presence_of(:time_zone) }

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

  describe "#end_time" do
    it "cannot be before #start_time" do
      event.end_time = event.start_time - 1.week
      expect(event).not_to be_valid
    end
  end

  describe "#time_zone" do
    it "defaults to Wellington" do
      expect(event.time_zone).to eq("Wellington")
    end
  end

  context "in the past" do
    before do
      start = Time.current - 1.year
      event.update! start_time: start, end_time: start + 1.week
    end

    it "is included in Event.past" do
      expect(Event.past).to include(event)
    end

    it "is not included in Event.current" do
      expect(Event.current).not_to include(event)
    end

    it "is not included in Event.upcoming" do
      expect(Event.upcoming).not_to include(event)
    end
  end

  context "in the future" do
    before do
      start = Time.current + 1.year
      event.update! start_time: start, end_time: start + 1.week
    end

    it "is not included in Event.past" do
      expect(Event.past).not_to include(event)
    end

    it "is not included in Event.current" do
      expect(Event.current).not_to include(event)
    end

    it "is included in Event.upcoming" do
      expect(Event.upcoming).to include(event)
    end
  end

  context "happening right now" do
    before do
      start = Time.current - 1.day
      event.update! start_time: start, end_time: start + 1.week
    end

    it "is not included in Event.past" do
      expect(Event.past).not_to include(event)
    end

    it "is included in Event.current" do
      expect(Event.current).to include(event)
    end

    it "is not included in Event.upcoming" do
      expect(Event.upcoming).not_to include(event)
    end
  end
end
