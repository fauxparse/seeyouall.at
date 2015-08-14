class UpdateLocation
  attr_reader :location

  def initialize(location, params)
    @location = location
    @params = params
  end

  def call
    location.with_lock do
      location.attributes = @params.except(:rooms)
      assign_rooms(@params[:rooms]) if @params[:rooms].present?
      location.save
    end
  end

  def location
    @presenter ||= LocationPresenter.new(@location)
  end

  protected

  def assign_rooms(rooms)
    ids = rooms.each.with_object([]) do |attrs, ids|
      id = attrs.delete(:id).to_i
      if !id.zero?
        ids << id
        find_room(id).attributes = attrs
      else
        @location.rooms.build(attrs)
      end
    end

    @location.rooms.each do |room|
      room.mark_for_destruction if !room.new_record? && ids.exclude?(room.id)
    end
  end

  def find_room(id)
    @location.rooms.detect { |r| r.id == id } ||
    @location.rooms.build
  end
end
