module ApplicationHelper
  def icon(icon, options = {})
    icon ||= "blank"
    options[:class] = "icon-#{icon} #{options[:class]}".strip
    content_tag :i, "", options
  end
end
