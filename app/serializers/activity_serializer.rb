class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :activity_type_id, :name, :description, :photo_url

  def photo_url
    object.activity_photos.first.try(:url)
  end
end
