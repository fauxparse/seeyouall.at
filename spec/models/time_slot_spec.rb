require 'rails_helper'

RSpec.describe TimeSlot, type: :model do
  subject(:time_slot) { event.time_slots.build }
  let(:event) { FactoryGirl.create(:event) }

  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }

  describe "#end_time" do
    it "cannot be before #start_time" do
      time_slot.start_time = Time.current
      time_slot.end_time = time_slot.start_time - 1.hour
      expect(time_slot).not_to be_valid
    end
  end
end
