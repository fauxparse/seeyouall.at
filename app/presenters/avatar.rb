class Avatar < Struct.new(:user)
  def render
    File.read(file).gsub("#000000", color.to_s)
  end

  protected

  def shape
    user.options["avatar"] || avatars[user.id % avatars.length]
  end

  def file
    File.join(base_dir, "#{shape}.svg")
  end

  def color
    if user.options.key?("color")
      Color[user.options["color"]]
    else
      Color.random(user.id)
    end
  end

  def avatars
    files.map { |f| File.basename(f, "*.svg") }
  end

  def files
    @@files ||= Dir["#{base_dir}/*.svg"].sort
  end

  def base_dir
    Rails.root.join("lib", "assets", "avatars")
  end
end
