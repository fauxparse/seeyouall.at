module ApplicationHelper
  def page_title(title = nil)
    title = if event.present?
      t("application.title_with_event", event: event.name)
    else
      t("application.title")
    end
    [content_for(:title), title].compact.join(" ║ ")
  end

  def icon(icon, options = {})
    add_class(options, "icon-#{icon || "blank"}")
    content_tag :i, "", options
  end

  def add_class(options, class_name)
    options[:class] = "#{class_name} #{options[:class]}".strip
  end
end
