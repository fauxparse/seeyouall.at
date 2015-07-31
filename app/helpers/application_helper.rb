module ApplicationHelper
  def icon(icon, options = {})
    add_class(options, "icon-#{icon || "blank"}")
    content_tag :i, "", options
  end

  def add_class(options, class_name)
    options[:class] = "#{class_name} #{options[:class]}".strip
  end
end
