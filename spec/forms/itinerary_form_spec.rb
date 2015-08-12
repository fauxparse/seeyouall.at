require "rails_helper"

describe ItineraryForm do
  subject(:form) { ItineraryForm.new(registration) }
  let(:registration) { FactoryGirl.create(:registration) }
  let(:activity_type) { FactoryGirl.create(:activity_type, event: registration.event) }

  def create_activity(name, start_time, end_time)
    slot = registration.event.time_slots.find_or_create_by!(start_time: start_time, end_time: end_time)
    activity = activity_type.activities.create!(name: name)
    slot.scheduled_activities.create!(activity: activity)
  end

  before do
    @activity1 = create_activity("1", "2015-08-10 10:00", "2015-08-10 12:00")
    @activity2 = create_activity("2", "2015-08-10 11:00", "2015-08-10 13:00")
    @activity3 = create_activity("3", "2015-08-10 14:00", "2015-08-10 16:00")
    registration.package.allocations.create(activity_type: activity_type, maximum: 5)
  end

  describe "#selections=" do
    it "adds activities" do
      form.selections = [@activity1.id]
      form.save!
      expect(Selection.count).to eq(1)
      expect(@activity1.reload.selections.size).to eq(1)
    end

    context "with activities selected" do
      before do
        form.selections = [@activity1.id]
        form.save!
      end

      it "removes old selections" do
        form.selections = []
        form.save!
        expect(Selection.count).to eq(0)
        expect(@activity1.reload.selections.size).to eq(0)
      end

      it "removes clashes" do
        form.selections = [@activity2.id]
        form.save!
        expect(Selection.count).to eq(1)
        expect(@activity1.reload.selections.size).to eq(0)
        expect(@activity2.reload.selections.size).to eq(1)
      end
    end

    context "when clashing activities are added at the same time" do
      before do
        form.selections = [@activity1.id, @activity2.id]
      end

      it "removes oldest first" do
        expect(form).to be_valid
        expect(form.schedules).to include(@activity2)
        expect(form.schedules).not_to include(@activity1)
      end
    end

    context "when the package does not include an allocation" do
      before do
        Allocation.destroy_all
        form.package.reload
        form.selections = [@activity1.id]
      end

      it "is invalid" do
        expect(form).not_to be_valid
        expect(form).to have(1).error_on(:selections)
      end
    end

    context "when the package allocation is exceeded" do
      before do
        Allocation.first.update!(maximum: 1)
        form.selections = [@activity1.id, @activity3.id]
      end

      it "is invalid" do
        expect(form).not_to be_valid
        expect(form).to have(1).error_on(:selections)
      end
    end

    context "when an activity is sold out" do
      before do
        @activity1.update(participant_limit: 1)
      end

      context "when someone else has registered" do
        before do
          someone_else = FactoryGirl.create(:ron)
          their_registration = Registration.create!(user: someone_else, event: registration.event, package: registration.package)
          their_registration.selections.create!(scheduled_activity: @activity1)
        end

        it "is invalid" do
          form.selections = [@activity1.id]
          expect(form).not_to be_valid
          expect(form).to have(1).error_on(:selections)
        end

        it "shows as sold out" do
          expect(form.schedule[@activity1.id]).to include(:sold_out)
        end
      end

      context "when this user has registered" do
        before do
          registration.selections.create!(scheduled_activity: @activity1)
        end

        it "is valid" do
          form.selections = [@activity1.id]
          expect(form).to be_valid
        end

        it "shows as sold out" do
          expect(form.schedule[@activity1.id]).to include(:sold_out)
        end
      end
    end
  end

  describe "#save!" do
    before do
      form.selections = [@activity1.id]
    end

    it "saves the changes" do
      expect { form.save! }.to change { Selection.count }.by(1)
    end
  end
end
