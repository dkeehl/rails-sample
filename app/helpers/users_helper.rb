module UsersHelper

  # return the Gravatar for the given user.
  def photo_for(user, size: 80)
    img = user.photo.file.nil? ? 'default.jpg' : user.photo.url
    image_tag(img, alt: user.name, class: 'gravatar', size: size)
  end

end
