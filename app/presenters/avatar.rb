class Avatar < Struct.new(:user)
  def render
    File.read(shape).gsub("#000000", color.to_s)
  end

  protected

  def shape
    avatars[user.id % avatars.length]
  end

  def color
    Color.random(user.id)
  end

  def avatars
    @@avatars ||= Dir[Rails.root.join("lib", "assets", "avatars", "*.svg")].sort
  end
end
