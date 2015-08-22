class EventPhoto < ActiveRecord::Base
  belongs_to :event
  belongs_to :photo

  after_destroy :destroy_photo

  delegate :url, to: :photo

  protected

  def destroy_photo
    photo.destroy
  end
end
