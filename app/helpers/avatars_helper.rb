module AvatarsHelper
  def avatar(user)
    image_tag(user_path(user, :svg), alt: user.name, class: "avatar")
  end
end
