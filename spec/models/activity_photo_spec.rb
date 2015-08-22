require "rails_helper"

RSpec.describe ActivityPhoto, type: :model do
  subject(:activity_photo) { ActivityPhoto.new(activity: activity, photo: photo) }
  let(:photo) { FactoryGirl.create(:photo) }
  let(:activity) { FactoryGirl.create(:activity) }

  it "destroys the photo when destroyed" do
    activity_photo.save
    expect { activity_photo.destroy }
      .to change { Photo.count }
      .from(1)
      .to(0)
  end
end
