module EventsHelper
  def current_event
    @current_event ||= try(:event).presence
  end

  def with_current_event
    yield current_event if current_event?
  end

  def event_header_link
    link_to(path_for_header_link, class: "logo") do
      concat content_tag(:span, t("header.title"), class: "see-you-all")
      concat content_tag(:span, t("header.title_short"), class: "see-you-all short")
      concat content_tag(:span, "@", class: "at")
      concat content_tag(:span, event.try(:name) || t("header.your_event_here"), class: "your-event-here")
    end
  end

  def path_for_header_link
    if current_event?
      event_path(current_event)
    else
      new_event_path
    end
  end

  def current_event?
    current_event.present? && current_event.persisted?
  end
end
