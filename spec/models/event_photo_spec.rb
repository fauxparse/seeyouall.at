require "rails_helper"

RSpec.describe EventPhoto, type: :model do
  subject(:event_photo) { EventPhoto.new(event: event, photo: photo) }
  let(:photo) { FactoryGirl.create(:photo) }
  let(:event) { FactoryGirl.create(:event) }

  it "destroys the photo when destroyed" do
    event_photo.save
    expect { event_photo.destroy }
      .to change { Photo.count }
      .from(1)
      .to(0)
  end
end
